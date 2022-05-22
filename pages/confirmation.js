import React, { useEffect, useState } from 'react'
import Image from "next/image";
import Card from '@mui/material/Card';
import Box from '@mui/material/Box';
import styles from "../styles/Home.module.css";
import Navbar from "../components/Navbar";
import CircularProgress from '@mui/material/CircularProgress';

export default function Confirmation({ timestamp = "March 14, 2023", txConfirmation = 'xxx0000034001294594503405848564', photo, }) {
    const [isloading, setIsloading] = useState([]);

    return isloading ? (
        <Box style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
        }}>
            <Navbar />
            <Box sx={{
                display: 'flex',
                // alignItems: 'center',
                // justifyContent: 'center',
                // flexDirection: 'column',

            }}>
                <Card sx={{
                    width: 300,
                    marginTop: 12,
                    boxShadow: 5
                }} >
                    <Box >
                        <h5 style={{ marginLeft: 15 }} >NFT Receipt</h5>
                    </Box>
                    <Image
                        src="/Images/person1.jpeg"
                        alt="Picture of the author"
                        width={230}
                        height={300}
                        layout='responsive'
                    />
                    <div>
                        <Box>
                            <h5 style={{ marginLeft: 15 }}>Confirmation page</h5>
                        </Box>
                        <h5 style={{ marginLeft: 15 }}>Date: {timestamp}</h5>
                        <h5 style={{ marginLeft: 15 }}>Transaction Confirmation: {txConfirmation}</h5>
                    </div>
                </Card>

            </Box>
        </Box>
    ) :
        <div>
            <Box sx={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                backgroundColor: 'red',
                flexDirection: 'column'
            }}>

                <CircularProgress />
            </Box>
        </div>

}