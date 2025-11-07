'use client'

import { useState } from 'react'
import { useWriteContract, useWaitForTransactionReceipt } from 'wagmi'
import { parseEther, formatEther } from 'viem'
import { MarketABI } from '@/lib/contracts'

type Market = {
  address: string
  targetPrice: string
  endTime: bigint
  state: number
  totalPoolAbove: string
  totalPoolBelow: string
  finalPrice: string
}

type PredictionModalProps = {
  market: Market
  isOpen: boolean
  onClose: () => void
}

export function PredictionModal({
  market,
  isOpen,
  onClose,
}: PredictionModalProps) {
  const [amount, setAmount] = useState('')
  const [isAbove, setIsAbove] = useState(true)
  const [error, setError] = useState('')

  const {
    writeContract,
    data: hash,
    isPending,
    error: writeError,
  } = useWriteContract()

  const { isLoading: isConfirming, isSuccess } =
    useWaitForTransactionReceipt({
      hash,
    })

  const handlePredict = async () => {
    setError('')
    
    if (!amount || parseFloat(amount) <= 0) {
      setError('Please enter a valid amount')
      return
    }

    try {
      writeContract({
        address: market.address as `0x${string}`,
        abi: MarketABI,
        functionName: 'predict',
        args: [isAbove],
        value: parseEther(amount),
      })
    } catch (err) {
      setError('Failed to submit prediction')
      console.error(err)
    }
  }

  if (!isOpen) return null

  if (isSuccess) {
    return (
      <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
        <div className="bg-gray-900 border border-gray-800 rounded-lg p-8 max-w-md w-full mx-4">
          <h2 className="text-2xl font-bold mb-4">Success!</h2>
          <p className="text-gray-400 mb-6">
            Your prediction has been submitted successfully.
          </p>
          <button
            onClick={onClose}
            className="w-full py-2 px-4 bg-blue-600 hover:bg-blue-700 rounded-lg font-medium"
          >
            Close
          </button>
        </div>
      </div>
    )
  }

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div className="bg-gray-900 border border-gray-800 rounded-lg p-8 max-w-md w-full mx-4">
        <h2 className="text-2xl font-bold mb-4">Make a Prediction</h2>

        <div className="mb-6">
          <p className="text-gray-400 mb-2">Target Price:</p>
          <p className="text-xl font-semibold">
            ${(Number(market.targetPrice) / 1e8).toFixed(2)}
          </p>
        </div>

        <div className="mb-6">
          <p className="text-gray-400 mb-4">Your Prediction:</p>
          <div className="flex gap-4">
            <button
              onClick={() => setIsAbove(true)}
              className={`flex-1 py-3 px-4 rounded-lg font-medium transition-colors ${
                isAbove
                  ? 'bg-green-600 text-white'
                  : 'bg-gray-800 text-gray-400 hover:bg-gray-700'
              }`}
            >
              Above
            </button>
            <button
              onClick={() => setIsAbove(false)}
              className={`flex-1 py-3 px-4 rounded-lg font-medium transition-colors ${
                !isAbove
                  ? 'bg-red-600 text-white'
                  : 'bg-gray-800 text-gray-400 hover:bg-gray-700'
              }`}
            >
              Below
            </button>
          </div>
        </div>

        <div className="mb-6">
          <label className="block text-gray-400 mb-2">Amount (ETH)</label>
          <input
            type="number"
            step="0.001"
            min="0"
            value={amount}
            onChange={(e) => setAmount(e.target.value)}
            className="w-full bg-gray-800 border border-gray-700 rounded-lg px-4 py-2 text-white focus:outline-none focus:border-blue-600"
            placeholder="0.0"
          />
        </div>

        {error && (
          <div className="mb-4 p-3 bg-red-900 border border-red-700 rounded-lg text-red-300 text-sm">
            {error}
          </div>
        )}

        {writeError && (
          <div className="mb-4 p-3 bg-red-900 border border-red-700 rounded-lg text-red-300 text-sm">
            {(writeError as Error).message || 'Transaction failed'}
          </div>
        )}

        <div className="flex gap-4">
          <button
            onClick={onClose}
            disabled={isPending || isConfirming}
            className="flex-1 py-2 px-4 bg-gray-800 hover:bg-gray-700 rounded-lg font-medium disabled:opacity-50"
          >
            Cancel
          </button>
          <button
            onClick={handlePredict}
            disabled={isPending || isConfirming || !amount}
            className="flex-1 py-2 px-4 bg-blue-600 hover:bg-blue-700 rounded-lg font-medium disabled:opacity-50"
          >
            {isPending || isConfirming ? 'Processing...' : 'Submit'}
          </button>
        </div>
      </div>
    </div>
  )
}

