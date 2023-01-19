const axios = require('axios');

// printf '{ "jsonrpc": "2.0", "id":1, "method": "Filecoin.ChainHead" }' | curl https://api.chain.love/rpc/v0 -s -XPOST -H 'Content-Type: application/json' -d@/dev/stdin  | jq -r '.result.Height'
function lotusBlockHeightRpc () {
  const url = "https://api.chain.love/rpc/v0"
  axios.post(url, { "jsonrpc": "2.0", "id":1, "method": "Filecoin.ChainHead" })
    .then(response => {
      console.log(response);
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
