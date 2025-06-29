require('dotenv').config();
const http = require('http');

const port = 3000;
const envName = process.env.ENVIRONMENT_NAME || 'unknown';

const server = http.createServer((req, res) => {
  if (req.url === '/') {
    res.writeHead(200, {'Content-Type': 'text/plain'});
    res.end(`Environment: ${envName}\n`);
  } else {
    res.writeHead(404);
    res.end('Not found');
  }
});

server.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});
