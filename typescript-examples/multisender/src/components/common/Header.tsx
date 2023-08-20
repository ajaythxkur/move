"use client"
import React from "react";
import styles from "./header.module.css";
import Link from "next/link";
import { toast } from 'react-hot-toast';
export default function Header() {

    function showDialog(id) {
        let element = document.getElementById(id);
        element.showModal();
    }
    function hideDialog(id) {
        let element = document.getElementById(id);
        element.close();
    }

    const walletOptions = [
        {
            name: "martian",
        },
        {
            name: "petra"
        },
        {
            name: "rise"
        }
    ];
    const AppRoutes = [
        {
            path: "/profile"
        },
        {
            path: "/trades"
        },
        {
            path: "/orders"
        }
    ];

    function connection(wallet) {
        switch (wallet) {
            case "martian":
                return martianConnect();
            case "petra":
                return petraConnect();
            case "rise":
                return riseConnect();
        }
    }
    async function martianConnect() {
        if (!("martian" in window)) {
            window.open("https://www.martianwallet.xyz/", "_blank");
            return;
        }
        const provider:any = window.martian;
        try {
            await provider.connect()
        } catch (err) {
            toast.error(err)
            return
        }
        const metadata = {
            address: true,
            application: true,
            chainId: true,
            message: "Approve interaction with immutable trade"
        };
        try{
            await provider.signMessage(metadata);
        }catch (err) {
            toast.error(err, {
                style: {
                    background: 'var(--text-black)',
                    color: 'var(--text-white)',
                    
                  },
            })
            return
        }
    }
    function petraConnect() {
        console.log("petra")
    }
    function riseConnect() {
        console.log('rise')
    }

    return (
        <React.Fragment>
            <nav className={`navbar ${styles.navsec}`}>
                <div className="container-fluid">
                    <Link href="/" className={`navbar-brand ${styles.logo}`}>
                        immutable trade
                    </Link>
                    <div className="d-flex align-items-center gap-md-3 gap-sm-2">
                        <div className="dropdown">
                            <ul className={`dropdown-menu ${styles.navdrop}`} id="nav-menu">
                                {AppRoutes.map((v, i) => {
                                    return (
                                        <li key={i}>
                                            <Link href={v.path} className={`${styles.headlink} dropdown-item d-flex gap-2`}>
                                                {v.path}
                                            </Link>
                                        </li>
                                    )
                                })}
                            </ul>
                        </div>
                        <button className={`btn ${styles.headbtn}`} onClick={() => showDialog('pop-dialog')}>login</button>
                        <button className={`btn ${styles.headbtn}`}>logout</button>
                    </div>
                </div>
            </nav>
            <hr />
            <dialog className={styles.modal} id="wallet-dialog">
                <div className="d-flex justify-content-end">
                    <button className={`btn ${styles.escbtn} border px-2 py-1`} onClick={() => hideDialog('wallet-dialog')}>esc</button>
                </div>
                <div className={styles.modalbox}>
                    {
                        walletOptions.map((v, i) => {
                            return (
                                <button className={`btn mb-2 w-100 ${styles.connectbtn}`} key={i} onClick={() => connection(v.name)}>{v.name}</button>
                            )
                        })
                    }
                </div>
            </dialog>

            <dialog className={styles.modal} id="pop-dialog">
                <div className="d-flex justify-content-end">
                    <button className={`btn ${styles.escbtn} border px-2 py-1`} onClick={() => hideDialog('pop-dialog')}>esc</button>
                </div>
                <div className={styles.popform}>
                    <form className="text-center">
                        <div className={`input-group rounded mb-3 px-2 ${styles.formbox}`}>
                            <span className={`input-group-text p-0 ${styles.inputgroup}`}>
                                <img src="/icons/avatar.png" alt="avatar" height={24} width={24} />
                            </span>
                            <input type="text" className={`form-control ${styles.inputtext}`} placeholder="Your name" />
                        </div>
                        <button className={`btn ${styles.confirmationbtn}`}>confirm</button>
                    </form>
                </div>
            </dialog>

        </React.Fragment>
    )
}