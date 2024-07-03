"use client"
import { useWallet, Wallet, WalletReadyState, isRedirectable, WalletName } from "@aptos-labs/wallet-adapter-react";
import { toast } from "sonner";
const buttonStyles = "nes-btn is-primary m-auto sm:m-0 sm:px-4";
export const WalletButtons = () => {
    const { wallets, connected, disconnect, isLoading } = useWallet();

    const onWalletDisconnectRequest = async () => {
        try {
            disconnect();
        } catch (error) {
            console.warn(error);
            toast.error("Failed to disconnect wallet. Please try again.");
        } finally {
            toast.success("Wallet successfully disconnected!");
        }
    };

    if (connected) {
        return (
            <div className="flex flex-row m-auto sm:m-0 sm:px-4">
                <div
                    className={`${buttonStyles} hover:bg-blue-700 btn-small`}
                    onClick={onWalletDisconnectRequest}
                >
                    Disconnect
                </div>
            </div>
        )
    }

    if (isLoading || !wallets[0]) {
        return (
            <div className={`${buttonStyles} opacity-50 cursor-not-allowed`}>
                Loading...
            </div>
        )
    }

    return <WalletView wallet={wallets[0]} />;
}

const WalletView = ({ wallet }: { wallet: Wallet }) => {
    const { connect } = useWallet();

    const isWalletReady = wallet.readyState === WalletReadyState.Installed || wallet.readyState === WalletReadyState.Loadable;
    const mobileSupport = wallet.deeplinkProvider;

    const onWalletConnectRequest = async (walletName: WalletName) => {
        try {
            await connect(walletName);
        } catch (error) {
            console.warn(error);
            toast.error("Failed to connect wallet. Please try again.");
        } finally {
            toast.success("Wallet successfully connected!");
        }
    }
    if (!isWalletReady && isRedirectable()) {
        if (mobileSupport) {
            return (
                <button
                    className={`${buttonStyles} hover:bg-blue-700`}
                    disabled={false}
                    key={wallet.name}
                    onClick={() => onWalletConnectRequest(wallet.name)}
                    style={{ maxWidth: "300px" }}
                >
                    Connect Wallet
                </button>
            )
        }
        return (
            <button
                className={`${buttonStyles} opacity-50 cursor-not-allowed`}
                disabled={true}
                key={wallet.name}
                style={{ maxWidth: "300px" }}
            >
                Connect Wallet - Desktop Only
            </button>
        )
    } else {
        return (
            <button
                className={`${buttonStyles} ${isWalletReady ? "hover:bg-blue-700" : "opacity-50 cursor-not-allowed"}`}
                disabled={!isWalletReady}
                key={wallet.name}
                onClick={() => onWalletConnectRequest(wallet.name)}
                style={{ maxWidth: "300px" }}
            >
                Connect Wallet
            </button>
        );
    }
}