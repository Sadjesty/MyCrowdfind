import web3 from './web3';
import CampaignFactory from './build/CompaignFactory.json';

const instance = new web3.eth.Contract (
	JSON.parse(CampaignFactory.interface),
    '0x2F4D8357e9b39CEB8cB0c16BF5fdEAC1B3667693'
);

export default instance;