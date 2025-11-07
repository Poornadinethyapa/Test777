'use client'

import { useState, useEffect } from 'react'
import { useAccount, useReadContract, usePublicClient } from 'wagmi'
import { formatEther } from 'viem'
import { WalletConnect } from '@/components/WalletConnect'
import { MarketCard } from '@/components/MarketCard'
import { PredictionModal } from '@/components/PredictionModal'
import { MarketFactoryABI, MarketABI } from '@/lib/contracts'
import { MARKET_FACTORY_ADDRESS } from '@/lib/contracts'

type Market = {
  address: string
  targetPrice: string
  endTime: bigint
  state: number
  totalPoolAbove: string
  totalPoolBelow: string
  finalPrice: string
}

export default function Home() {
  const { address, isConnected } = useAccount()
  const publicClient = usePublicClient()
  const [markets, setMarkets] = useState<Market[]>([])
  const [selectedMarket, setSelectedMarket] = useState<Market | null>(null)
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [loading, setLoading] = useState(false)

  // Read all markets from factory
  const { data: allMarkets } = useReadContract({
    address: MARKET_FACTORY_ADDRESS,
    abi: MarketFactoryABI,
    functionName: 'getAllMarkets',
    query: {
      enabled: isConnected,
    },
  })

  // Fetch market details
  useEffect(() => {
    const fetchMarkets = async () => {
      if (!allMarkets || !publicClient || !isConnected) {
        setMarkets([])
        return
      }

      setLoading(true)
      try {
        const marketAddresses = allMarkets as `0x${string}`[]
        const marketData = await Promise.all(
          marketAddresses.map(async (marketAddress) => {
            try {
              const details = await publicClient.readContract({
                address: marketAddress,
                abi: MarketABI,
                functionName: 'getMarketDetails',
              })

              const [
                targetPrice,
                endTime,
                state,
                totalPoolAbove,
                totalPoolBelow,
                finalPrice,
              ] = details as [bigint, bigint, number, bigint, bigint, bigint]

              return {
                address: marketAddress,
                targetPrice: targetPrice.toString(),
                endTime,
                state,
                totalPoolAbove: totalPoolAbove.toString(),
                totalPoolBelow: totalPoolBelow.toString(),
                finalPrice: finalPrice.toString(),
              } as Market
            } catch (error) {
              console.error('Error fetching market:', error)
              return null
            }
          })
        )

        setMarkets(marketData.filter((m): m is Market => m !== null && m.address !== ''))
      } catch (error) {
        console.error('Error fetching markets:', error)
        setMarkets([])
      } finally {
        setLoading(false)
      }
    }

    fetchMarkets()
  }, [allMarkets, publicClient, isConnected])

  const handlePredict = (market: Market) => {
    setSelectedMarket(market)
    setIsModalOpen(true)
  }

  if (!isConnected) {
    return (
      <main className="flex min-h-screen flex-col items-center justify-center p-24">
        <div className="z-10 max-w-5xl w-full items-center justify-center text-center">
          <h1 className="text-6xl font-bold mb-8">Predict and Win</h1>
          <p className="text-xl mb-12 text-gray-400">
            Decentralized prediction markets on Ethereum
          </p>
          <WalletConnect />
        </div>
      </main>
    )
  }

  return (
    <main className="flex min-h-screen flex-col p-8">
      <div className="z-10 max-w-7xl w-full mx-auto">
        <div className="flex justify-between items-center mb-8">
          <div>
            <h1 className="text-4xl font-bold mb-2">Predict and Win</h1>
            <p className="text-gray-400">
              Connected: {address?.slice(0, 6)}...{address?.slice(-4)}
            </p>
          </div>
          <WalletConnect />
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {loading ? (
            <div className="col-span-full text-center py-12">
              <p className="text-gray-400 text-lg">Loading markets...</p>
            </div>
          ) : markets.length === 0 ? (
            <div className="col-span-full text-center py-12">
              <p className="text-gray-400 text-lg">
                No markets available. Create one to get started!
              </p>
            </div>
          ) : (
            markets.map((market) => (
              <MarketCard
                key={market.address}
                market={market}
                onPredict={() => handlePredict(market)}
              />
            ))
          )}
        </div>

        {isModalOpen && selectedMarket && (
          <PredictionModal
            market={selectedMarket}
            isOpen={isModalOpen}
            onClose={() => setIsModalOpen(false)}
          />
        )}
      </div>
    </main>
  )
}

