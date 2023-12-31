

#[cfg(test)]
mod testing_trade {
    #[test]
    #[available_gas(600000000)]
    fn test_trade() {
        let game_id = 1;

        let price = 100;
        let quantity = 100;
        let item_id = 1;

        // seller
        let mut seller_gold_balance = ItemBalance {
            game_id, player_id: get_caller_address(), item_id: 999, balance: 0
        };
        let mut seller_item_balance = ItemBalance {
            game_id, player_id: get_caller_address(), item_id, balance: quantity
        };

        // trade
        let mut trade = Trade {
            entity_id: 1,
            game_id,
            item_id,
            quantity,
            price,
            status: TradeStatus::OPEN,
            player_id: get_caller_address(),
            game_id_value: game_id
        };

        trade.create_trade(ref seller_item_balance);
        assert(seller_item_balance.balance == 0, 'seller item balance is not 0');

        let mut buyer_gold_balance = ItemBalance {
            game_id, player_id: 1.try_into().unwrap(), item_id: 999, balance: 100
        };
        let mut buyer_item_balance = ItemBalance {
            game_id, player_id: 1.try_into().unwrap(), item_id, balance: 0
        };


        assert(buyer_gold_balance.balance == price, 'buyer gold balance is not 100');
        assert(buyer_item_balance.balance == 0, 'buyer item balance is not 0');

        trade
            .accept_trade(
                ref buyer_gold_balance, ref seller_gold_balance, ref buyer_item_balance, game_id
            );

        assert(buyer_gold_balance.balance == 0, 'buyer gold balance is not 0');
        assert(seller_gold_balance.balance == price, 'seller gold balance is not 100');
        assert(buyer_item_balance.balance == quantity, 'buyer item balance is not 100');
    }
}