const express = require('express');
const cors = require('cors');
const fetch = require('node-fetch');

const app = express();
app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
    res.sendFile(__dirname + '/index.html');
});

app.get('/api/bypass', async (req, res) => {
    const targetUrl = req.query.url;
    if (!targetUrl) return res.status(400).json({ error: 'URL tidak boleh kosong' });

    try {
        const response = await fetch(`https://api.bypass.vip/bypass?url=${encodeURIComponent(targetUrl)}`);
        const data = await response.json();

        if (data.status === 'success' || data.result) {
            res.json({ success: true, key: data.result || data.destination });
        } else {
            res.status(500).json({ success: false, message: 'Gagal me-bypass link.' });
        }
    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
