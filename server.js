const { default: makeWASocket, useMultiFileAuthState, DisconnectReason } = require('@whiskeysockets/baileys');
const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const qrcode = require('qrcode');

const app = express();
const server = http.createServer(app);
const io = new Server(server);

let qrCodeData = null;
let groupCache = {}; // Cache nama grup

// Serve HTML Dashboard
app.get('/', (req, res) => {
    res.send(`
    <!DOCTYPE html>
    <html lang="id">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>WTB Group Monitor</title>
        <script src="/socket.io/socket.io.js"></script>
        <style>
            body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background: #0f172a; color: #f8fafc; margin: 0; padding: 20px; }
            .container { max-width: 800px; margin: 0 auto; }
            h1 { color: #38bdf8; text-align: center; }
            #qr-container { text-align: center; margin: 20px 0; background: #1e293b; padding: 20px; border-radius: 10px; }
            #qr-image { max-width: 250px; border-radius: 8px; }
            .feed-item { background: #1e293b; border-left: 4px solid #38bdf8; padding: 15px; margin-bottom: 12px; border-radius: 6px; }
            .group-title { font-weight: bold; color: #f43f5e; margin-bottom: 4px; font-size: 1.1em; }
            .group-link { color: #38bdf8; text-decoration: none; }
            .group-link:hover { text-decoration: underline; }
            .sender { font-size: 0.9em; color: #94a3b8; margin-bottom: 8px; }
            .message-text { font-size: 1.05em; color: #f1f5f9; white-space: pre-wrap; background: #0f172a; padding: 10px; border-radius: 4px; }
            .time { font-size: 0.75em; color: #64748b; margin-top: 6px; text-align: right; }
            .status { text-align: center; font-weight: bold; padding: 8px; border-radius: 5px; margin-bottom: 15px; }
            .connected { background: #065f46; color: #34d399; }
            .disconnected { background: #881337; color: #fecdd3; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>📡 Live WTB Detector</h1>
            <div id="status" class="status disconnected">Memuat Server...</div>
            
            <div id="qr-container" style="display: none;">
                <h3>Scan QR Code Ini via WhatsApp:</h3>
                <img id="qr-image" src="" alt="QR Code">
            </div>

            <h2>Recent WTB Activity</h2>
            <div id="feed-list"></div>
        </div>

        <script>
            const socket = io();
            const qrContainer = document.getElementById('qr-container');
            const qrImage = document.getElementById('qr-image');
            const statusDiv = document.getElementById('status');
            const feedList = document.getElementById('feed-list');

            socket.on('qr', (url) => {
                qrImage.src = url;
                qrContainer.style.display = 'block';
                statusDiv.innerText = 'Silakan Scan QR Code';
                statusDiv.className = 'status disconnected';
            });

            socket.on('ready', () => {
                qrContainer.style.display = 'none';
                statusDiv.innerText = '🟢 WhatsApp Terhubung & Monitoring Aktif!';
                statusDiv.className = 'status connected';
            });

            socket.on('new-wtb', (data) => {
                const item = document.createElement('div');
                item.className = 'feed-item';
                
                const cleanGroupJid = data.groupJid.replace('@g.us', '');
                const groupLink = 'https://wa.me/g/' + cleanGroupJid;

                item.innerHTML = \`
                    <div class="group-title">
                        📌 Grup: <a href="\${groupLink}" target="_blank" class="group-link">\${data.groupName}</a>
                    </div>
                    <div class="sender">👤 Pengirim: +\${data.sender.split('@')[0]}</div>
                    <div class="message-text">\${data.text}</div>
                    <div class="time">\${new Date(data.timestamp * 1000).toLocaleTimeString()}</div>
                \`;
                feedList.prepend(item);
            });
        </script>
    </body>
    </html>
    `);
});

async function connectToWhatsApp() {
    const { state, saveCreds } = await useMultiFileAuthState('baileys_auth');
    const sock = makeWASocket({
        auth: state,
        printQRInTerminal: true
    });

    sock.ev.on('creds.update', saveCreds);

    sock.ev.on('connection.update', async (update) => {
        const { connection, lastDisconnect, qr } = update;
        
        if (qr) {
            qrcode.toDataURL(qr, (err, url) => {
                if (!err) {
                    qrCodeData = url;
                    io.emit('qr', url);
                }
            });
        }

        if (connection === 'open') {
            console.log('WhatsApp Terhubung!');
            io.emit('ready');
            
            // Sync nama grup
            try {
                const groups = await sock.groupFetchAllParticipating();
                for (let id in groups) {
                    groupCache[id] = groups[id].subject;
                }
            } catch (e) {
                console.log('Gagal fetch grup:', e);
            }
        } else if (connection === 'close') {
            const shouldReconnect = (lastDisconnect.error?.output?.statusCode !== DisconnectReason.loggedOut);
            if (shouldReconnect) {
                connectToWhatsApp();
            }
        }
    });

    sock.ev.on('messages.upsert', async (m) => {
        const msg = m.messages[0];
        if (!msg.message || msg.key.fromMe) return;

        const remoteJid = msg.key.remoteJid;
        if (!remoteJid || !remoteJid.endsWith('@g.us')) return; // Hanya grup

        // Ambil isi teks
        const text = msg.message.conversation || 
                     msg.message.extendedTextMessage?.text || 
                     msg.message.imageMessage?.caption || '';

        // Deteksi kata kunci WTB (Case-insensitive)
        if (/\bwtb\b/i.test(text)) {
            const groupName = groupCache[remoteJid] || 'Grup WA';
            const sender = msg.key.participant || msg.participant || remoteJid;

            console.log(`[WTB DETECTED] ${groupName}: ${text}`);

            // Kirim ke Dashboard Real-time
            io.emit('new-wtb', {
                groupJid: remoteJid,
                groupName: groupName,
                sender: sender,
                text: text,
                timestamp: msg.messageTimestamp
            });
        }
    });
}

connectToWhatsApp();

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
    console.log(`Server berjalan di port ${PORT}`);
});
