import './globals.css'
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import "bootstrap/dist/css/bootstrap.css"
const inter = Inter({ subsets: ['latin'] })
import Header from "@/components/common/Header"
import Footer from '@/components/common/Footer'
export const metadata: Metadata = {
  title: 'Multi Sender - Aptos',
  description: 'Multi sender on aptos blockchain created by Immutable Legends',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <Header />
        {children}
        <Footer />
      </body>
    </html>
  )
}
