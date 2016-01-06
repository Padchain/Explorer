class SessionsController < ApplicationController

  require 'json'
  require 'logger'

  def index
    @info = BitcoinRpc.new('http://multichainrpc:' + ENV['PADCHAIN_NODE_KEY'] + '@' + ENV['PADCHAIN_NODE_ADDRESS'] + ':6306/').getinfo
    @circulation = BitcoinRpc.new('http://multichainrpc:' + ENV['PADCHAIN_NODE_KEY'] + '@' + ENV['PADCHAIN_NODE_ADDRESS'] + ':6306/').getbalance
    @assets = BitcoinRpc.new('http://multichainrpc:' + ENV['PADCHAIN_NODE_KEY'] + '@' + ENV['PADCHAIN_NODE_ADDRESS'] + ':6306/').listassets

    block = @info['blocks']

    block_count = block.to_i - 9

    puts block_count

    @current_block = []

    x = 0

    10.times do
      block_hash = BitcoinRpc.new('http://multichainrpc:' + ENV['PADCHAIN_NODE_KEY'] + '@' + ENV['PADCHAIN_NODE_ADDRESS'] + ':6306/').getblockhash(block_count)
      @current_block[x] = BitcoinRpc.new('http://multichainrpc:' + ENV['PADCHAIN_NODE_KEY'] + '@' + ENV['PADCHAIN_NODE_ADDRESS'] + ':6306/').getblock(block_hash)
      x = x + 1
      block_count = block_count + 1
    end

  end

end
