import React from 'react'
import Image from "next/image";
import Card from '@mui/material/Card';
import { useEffect, useState } from "react";
import styles from "../styles/Experiences.module.css";

export default function Experiences({ props }) {
    const { city, duration, price, photo } = props;
    return (
        <div style={styles.container}>
            <Card style={styles.card} variant="outlined">
                <h1 style={styles.title} className='title' >Experiences</h1>
                <br />
                <h3>Experience{city}</h3>
                <h3>Experience {duration}</h3>
                <h3>Price{price}</h3>
                <Image alt='NFT Image' src={photo} width={100} height={100} />
            </Card>
        </div>
    )
}
