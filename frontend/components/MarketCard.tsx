'use client'

import { formatEther } from 'viem'
import { formatDistance } from 'date-fns'

type Market = {
  address: string
  targetPrice: string
  endTime: bigint
  state: number
  totalPoolAbove: string
  totalPoolBelow: string
  finalPrice: string
}

type MarketCardProps = {
  market: Market
  onPredict: () => void
}

const MarketState = {
  0: 'Open',
  1: 'Closed',
  2: 'Resolved',
}

export function MarketCard({ market, onPredict }: MarketCardProps) {
  const isOpen = market.state === 0
  const isResolved = market.state === 2
  const endDate = new Date(Number(market.endTime) * 1000)
  const timeRemaining = isOpen
    ? formatDistance(endDate, new Date(), { addSuffix: true })
    : 'Ended'

  const totalPool = BigInt(market.totalPoolAbove) + BigInt(market.totalPoolBelow)

  return (
    <div className="bg-gray-900 border border-gray-800 rounded-lg p-6 hover:border-gray-700 transition-colors">
      <div className="flex justify-between items-start mb-4">
        <div>
          <h3 className="text-xl font-semibold mb-2">ETH/USD Prediction</h3>
          <p className="text-sm text-gray-400">
            Target: ${(Number(market.targetPrice) / 1e8).toFixed(2)}
          </p>
        </div>
        <span
          className={`px-3 py-1 rounded-full text-xs font-medium ${
            isOpen
              ? 'bg-green-900 text-green-300'
              : isResolved
              ? 'bg-blue-900 text-blue-300'
              : 'bg-gray-800 text-gray-400'
          }`}
        >
          {MarketState[market.state as keyof typeof MarketState]}
        </span>
      </div>

      <div className="space-y-3 mb-4">
        <div className="flex justify-between text-sm">
          <span className="text-gray-400">Time Remaining:</span>
          <span className="text-white">{timeRemaining}</span>
        </div>

        <div className="flex justify-between text-sm">
          <span className="text-gray-400">Pool Above:</span>
          <span className="text-green-400">
            {formatEther(BigInt(market.totalPoolAbove))} ETH
          </span>
        </div>

        <div className="flex justify-between text-sm">
          <span className="text-gray-400">Pool Below:</span>
          <span className="text-red-400">
            {formatEther(BigInt(market.totalPoolBelow))} ETH
          </span>
        </div>

        <div className="flex justify-between text-sm pt-2 border-t border-gray-800">
          <span className="text-gray-400">Total Pool:</span>
          <span className="text-white font-semibold">
            {formatEther(totalPool)} ETH
          </span>
        </div>

        {isResolved && market.finalPrice !== '0' && (
          <div className="flex justify-between text-sm pt-2 border-t border-gray-800">
            <span className="text-gray-400">Final Price:</span>
            <span className="text-white font-semibold">
              ${(Number(market.finalPrice) / 1e8).toFixed(2)}
            </span>
          </div>
        )}
      </div>

      <button
        onClick={onPredict}
        disabled={!isOpen}
        className={`w-full py-2 px-4 rounded-lg font-medium transition-colors ${
          isOpen
            ? 'bg-blue-600 hover:bg-blue-700 text-white'
            : 'bg-gray-800 text-gray-500 cursor-not-allowed'
        }`}
      >
        {isOpen ? 'Make Prediction' : isResolved ? 'Resolved' : 'Closed'}
      </button>
    </div>
  )
}

