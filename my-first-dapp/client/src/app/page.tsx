"use client";
import { Button, Col, Layout, Row } from "antd";
import { PetraWallet } from "petra-plugin-wallet-adapter";
import { AptosWalletAdapterProvider, useWallet, InputTransactionData } from "@aptos-labs/wallet-adapter-react";
import { WalletSelector } from "@aptos-labs/wallet-adapter-ant-design";
import { Aptos, AptosConfig, Network } from "@aptos-labs/ts-sdk";
import "@aptos-labs/wallet-adapter-ant-design/dist/index.css";
import { useEffect, useState } from "react";

export default function Home() {
  const wallets = [new PetraWallet()];
  const aptosConfig = new AptosConfig({ network: Network.DEVNET });
  const aptos = new Aptos(aptosConfig);
  const { account, signAndSubmitTransaction } = useWallet();
  const [accountHasList, setAccountHasList] = useState<boolean>(false);
  const moduleAddress = "0xbbfe48a769918ef5d3f70add902e241a0b1813a5b579cfc04a525b3aa383d47e";
  const fetchList = async () => {
    if (!account) return;
    try {
      const todoListResource = await aptos.getAccountResource({
        accountAddress: account.address,
        resourceType: `${moduleAddress}::todolist::TodoList`
      })
      setAccountHasList(true)
    } catch (e: any) {
      setAccountHasList(false)
    }
  }
  const addNewList = async() => {
    if(!account) return;
    const transaction: InputTransactionData = {
      data:{
        function: `${moduleAddress}::todolist::create_list`,
        functionArguments: []
      }
    }
    try{
      const response = await signAndSubmitTransaction(transaction);
      await aptos.waitForTransaction({ transactionHash: response.hash });
      setAccountHasList(true)
    }catch(e: any){
      setAccountHasList(false)
    }
  }
  useEffect(() => {
    fetchList()
  }, [account?.address])
  console.log({account}) /// wtf
  return (
    <>
      <AptosWalletAdapterProvider plugins={wallets} autoConnect={true}>
        <Layout>
          <Row align="middle">
            <Col span={10} offset={2}>
              <h1>Our todolist</h1>
            </Col>
            <Col span={12} style={{ textAlign: "right", paddingRight: "200px" }}>
              <WalletSelector />
            </Col>
          </Row>
        </Layout>
        {!accountHasList && (
          <Row gutter={[0, 32]} style={{ marginTop: "2rem" }}>
            <Col span={8} offset={8}>
              <Button
                onClick={addNewList}
                block
                type="primary"
                style={{ height: "40px", backgroundColor: "#3f67ff" }}
              >
                Add new list
              </Button>
            </Col>
          </Row>
        )}
      </AptosWalletAdapterProvider>
    </>
  );
}
