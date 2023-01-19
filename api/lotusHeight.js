const axios = require('axios');
const { URL, parse } = require('url');


function isValidUrl(urlString) {
  try { 
    return Boolean(new URL(urlString)); 
  }
  catch(e){ 
    return false; 
  }
}

function getLotusNodeUrl() {
  console.log('getLotusNodeUrl() ...');
  console.log(`process.env.FULLNODE_API_INFO: ${process.env.FULLNODE_API_INFO}`);
  if (process.env.FULLNODE_API_INFO && isValidUrl(process.env.FULLNODE_API_INFO)) {
    console.log(`using FULLNODE_API_INFO:${process.env.FULLNODE_API_INFO}`);
    const fnai = new URL(process.env.FULLNODE_API_INFO)
    return `${fnai.protocol}://${fnai.hostname}${fnai.port ? ':'+fnai.port : ''}/rpc/v0`
  }
  // TODO localhost, wss.
  return "https://api.chain.love/rpc/v0";
}

// printf '{ "jsonrpc": "2.0", "id":1, "method": "Filecoin.ChainHead" }' | curl https://api.chain.love/rpc/v0 -s -XPOST -H 'Content-Type: application/json' -d@/dev/stdin  | jq -r '.result.Height'
function lotusBlockHeightRpc () {
  const url = getLotusNodeUrl();
  console.log(`lotusBlockHeightRpc. url: ${url}`)
  axios.post(url, { "jsonrpc": "2.0", "id":1, "method": "Filecoin.ChainHead" })
    .then(response => {
      console.log("Status : " + response.status);
      console.log("Height : " + response.data.result.Height);
    }, (error) => {
      console.log(error);
    });
}

function testGet () {
    const url = "https://github.com/frank-ang/"
    axios.get(url).then(resp => {
      console.log(resp.data);
    });
  }

lotusBlockHeightRpc();
