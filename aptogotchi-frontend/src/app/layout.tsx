import type { Metadata } from "next";
import "./globals.css";
import localFont from "next/font/local"
import { Toaster } from "sonner";
import { WalletProvider } from "@/context/WalletProvider";
import "nes.css/css/nes.min.css";
import { PetProvider } from "@/context/PetContext";
const kongtext = localFont({
  src: "./../../public/kongtext.ttf",
  variable: "--font-kongtext"
})

export const metadata: Metadata = {
  title: "Aptogotchi",
  description: "Your favorite on-chain pet!",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className={kongtext.className}>
        <Toaster
          richColors
          position="top-right"
          closeButton
          expand={true}
        />
        <PetProvider>
          <WalletProvider>
            {children}
          </WalletProvider>
        </PetProvider>
      </body>

    </html>
  );
}
