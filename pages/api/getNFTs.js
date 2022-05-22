// Next.js API route support: https://nextjs.org/docs/api-routes/introduction

export default function handler(req, res) {
    // this when you're live you'll get from the rpc call
    const MockNFTData = [
        {
        expId: '01',
        expName: 'Kayak Through Biscayne Bay',
        expLocation: 'Miami',
        expDate: 'Tomorrow',
        expDesc: 'earn about Miami&apos;s brand new city center in the financial district. After a bit of retail therapy we&apos;re going to swing over the world famous art district called Wynwood.',
        expPrice: '$999.99',
        },
        {
        expId: '02',
        expName: 'Brickell City Center &amp; Wynwood',
        expLocation: 'Miami',
        expDate: 'Tomorrow',
        expDesc: 'earn about Miami&apos;s brand new city center in the financial district. After a bit of retail therapy we&apos;re going to swing over the world famous art district called Wynwood.',
        expPrice: '$999.99',
        },
        {
        expId: '03',
        expName: 'Historic Calle Ocho',
        expLocation: 'Miami',
        expDate: 'Tomorrow',
        expDesc: 'earn about Miami&apos;s brand new city center in the financial district. After a bit of retail therapy we&apos;re going to swing over the world famous art district called Wynwood.',
        expPrice: '$999.99',
        },
        {
        expId: '04',
        expName: 'Coconut Grove Tour',
        expLocation: 'Miami',
        expDate: 'Yesterday',
        expDesc: 'earn about Miami&apos;s brand new city center in the financial district. After a bit of retail therapy we&apos;re going to swing over the world famous art district called Wynwood.',
        expPrice: '$999.99',
        }
    ]
    res.status(200).json( MockNFTData )
  }