class SessionsController < ApplicationController

  require 'json'
  require 'logger'

  def index
    @info = BitcoinRpc.new('http://multichainrpc:' + ENV['PADCHAIN_NODE_KEY'] + '@' + ENV['PADCHAIN_NODE_ADDRESS'] + ':6306/').getinfo
    @circulation = BitcoinRpc.new('http://multichainrpc:' + ENV['PADCHAIN_NODE_KEY'] + '@' + ENV['PADCHAIN_NODE_ADDRESS'] + ':6306/').getbalance
    @assets = BitcoinRpc.new('http://multichainrpc:' + ENV['PADCHAIN_NODE_KEY'] + '@' + ENV['PADCHAIN_NODE_ADDRESS'] + ':6306/').listassets
    @network_hash = BitcoinRpc.new('http://multichainrpc:' + ENV['PADCHAIN_NODE_KEY'] + '@' + ENV['PADCHAIN_NODE_ADDRESS'] + ':6306/').getnetworkhashps / 1000
    @unconfirmed_transactions = BitcoinRpc.new('http://multichainrpc:' + ENV['PADCHAIN_NODE_KEY'] + '@' + ENV['PADCHAIN_NODE_ADDRESS'] + ':6306/').getmempoolinfo

    if BitcoinRpc.new('http://multichainrpc:' + ENV['PADCHAIN_NODE_KEY'] + '@' + ENV['PADCHAIN_NODE_ADDRESS'] + ':6306/').getinfo['blocks'] = BitcoinRpc.new('http://multichainrpc:' + ENV['PADCHAIN_NODE_KEY'] + '@' + ENV['PADCHAIN_NODE_ADDRESS'] + ':6306/').getblockchaininfo['blocks']
      @sync_status = "synched"
      @sync_text = "IN SYNC"
    else
      @sync_status = "behind"
      @sync_text = "BEHIND"
    end

    block = @info['blocks']

    block_count = block.to_i - 9

    puts block_count

    @current_block = []
    x = 0
    @tx_count = 0

    5.times do
      block_hash = BitcoinRpc.new('http://multichainrpc:' + ENV['PADCHAIN_NODE_KEY'] + '@' + ENV['PADCHAIN_NODE_ADDRESS'] + ':6306/').getblockhash(block_count)
      @current_block[x] = BitcoinRpc.new('http://multichainrpc:' + ENV['PADCHAIN_NODE_KEY'] + '@' + ENV['PADCHAIN_NODE_ADDRESS'] + ':6306/').getblock(block_hash)
      x = x + 1
      block_count = block_count + 1
    end

    @current_block.reverse.each do |c|
      c['tx'].each do |t|
        @tx_count = @tx_count + 1
      end
    end

  end

end
