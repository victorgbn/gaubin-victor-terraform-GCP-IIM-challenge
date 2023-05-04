const axios = require('axios');

async function getData() {
  const url = 'https://randomuser.me/api/';
  const response = await axios.get(url);
  const data = response.data.results[0];
  return data;
}

getData().then(data => console.log(data)).catch(error => console.error(error));