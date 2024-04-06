import { ZkSendLinkBuilder ,listCreatedLinks,ZkSendLink} from '@mysten/zksend';
import getExecStuff from './execStuff';


// import { ZkSendLink, ZkSendLinkBuilder } from './index.ts';

import { TransactionBlock } from '@mysten/sui.js/transactions';
import { expect, test } from 'vitest';


export const DEMO_BEAR_CONFIG = {
	packageId: '0xab8ed19f16874f9b8b66b0b6e325ee064848b1a7fdcb1c2f0478b17ad8574e65',
	type: '0xab8ed19f16874f9b8b66b0b6e325ee064848b1a7fdcb1c2f0478b17ad8574e65::demo_bear::DemoBear',
};


async function zkSendExample() {

    const ZK_BAG_CONFIG = {
        packageId: '0x036fee67274d0d85c3532f58296abe0dee86b93864f1b2b9074be6adb388f138',
        bagStoreId: '0x5c63e71734c82c48a3cb9124c54001d1a09736cfb1668b3b30cd92a96dd4d0ce',
        bagStoreTableId: '0x4e1bc4085d64005e03eb4eab2510d527aeba9548cda431cb8f149ff37451f870',
    };

    const { keypair, client } = getExecStuff();

    const link = new ZkSendLinkBuilder({
        sender: '0xe4d50e97aae5f0c22d6e99145abdd1a5b0f4552c6a23a66e615629231753ddf9',
        contract: ZK_BAG_CONFIG,
        client: client,
    });

    link.addClaimableMist(BigInt(1000000));
    const linkUrl = link.getLink();

    await link.create({
        signer: keypair,
        waitForTransactionBlock: true,
    });

    const claimLink = await ZkSendLink.fromUrl(linkUrl, {
        contract: ZK_BAG_CONFIG,
        network: 'testnet',
        claimApi: 'https://zksend-git-mh-contract-claims-mysten-labs.vercel.app/api',
    });

    const claimableAssets = claimLink.assets!;
    
    console.log(linkUrl);
    console.log(claimLink.claimed);
    console.log(linkUrl);
    console.log(claimLink.claimed);


    // const {
    //     links: [lostLink],
    // } = await listCreatedLinks({
    //     address: keypair.toSuiAddress(),
    //     network: 'testnet',
    //     contract: ZK_BAG_CONFIG,
    // });

    // const { url, transactionBlock } = await lostLink.link.createRegenerateTransaction(
    //     keypair.toSuiAddress(),
    // );

    // const result = await client.signAndExecuteTransactionBlock({
    //     transactionBlock,
    //     signer: keypair,
    //     options: {
    //         showEffects: true,
    //         showObjectChanges: true,
    //     },
    // });

    // await client.waitForTransactionBlock({ digest: result.digest });
    
    // const link2 = await ZkSendLink.fromUrl(linkUrl, {
    //     contract: ZK_BAG_CONFIG,
    //     network: 'testnet',
    //     claimApi: 'https://zksend-git-mh-contract-claims-mysten-labs.vercel.app/api',
    // });
    // const claimLink = await ZkSendLink.fromUrl(linkUrl, {
    //     contract: ZK_BAG_CONFIG,
    //     network: 'testnet',
    //     claimApi: 'https://zksend-git-mh-contract-claims-mysten-labs.vercel.app/api',
    // }); 





    



    // // await link.create({
    // //     signer: keypair,
    // // });
    // txb.setSender('0xe4d50e97aae5f0c22d6e99145abdd1a5b0f4552c6a23a66e615629231753ddf9');


    // console.log({ result });

    // console.log(link.getLink());

   
}


zkSendExample()
