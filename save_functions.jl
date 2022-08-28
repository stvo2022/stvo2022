Tst_string =  ["N","t","tt","s","st","stt","ss","sst","sstt","N","Tt","Ttt","Ts","N","Tstt","Tss","ttss"]
xpm_string = ["N","m","mm","p","pm","pmm","pp","ppm","ppmm","x","xm","xmm","xp","N","xmpp","xpp","xmmp","xmmpp","xx","xxm",
"xxmm","xxp","xxp","xxmpp","xxmm","xxmpp","xxmm","xxmmp","xxmmxx"]

function show_deck(deck::Deck)
    for x in deck
        print(Card[x], " Suit:[", suit(x), " ] Rank: ", rank(x), "] Value:", x.value,"\n")
    end
end


# check for 2, 3 and 4 of a kind from player_hand
function find_23ofakind(inCard::Card, hand::Deck)

    player_newhand = Any[] # new hand after matched cards being removed
    player_assets = Any[] # player's assets card needs to be added to the "pile"
    #("Card: ", inCard, " \nhand:",hand)
    for (i, card) in enumerate(hand)
        if (string(card) == string(inCard))
            push!(player_assets,card)
        else
            push!(player_newhand, card)
        end
    end

    return(player_newhand, player_assets) # return a new hand and assets

end

function find_groupTSTXPM(inCard::Card, hand::Deck) 
# 3 of a kind already checked prior to this logic
    TT = 0; ss = 0; tt = 0; xx = 0; pp = 0; mm = 0;
    
    Tst = xpm = string(inCard)[1]
    println("Card:" , inCard)

    if ((Tst=='T' || Tst=='s' || Tst=='t') )
        for c in hand.cards 
            if(suit(inCard) == suit(c))
                s1 = string(c)[1]
                if (s1 == 'T')
                    TT+=1
                elseif (s1 =='s')
                    ss+=1
                elseif (s1 == 't')
                    tt+=1
                else
                    ;;
                end
            end
        end
  
        println("Tst1 :", TT,ss,tt)

        # check for possible matches - Tst/Ts/Tt/ts + 1s/2t;1s/0t;2s/1t & 1t/0s, etc.
        if (TT>2)
            TT = 0
        elseif(TT>1) TT = 1
        else
            ;;
        end
        if (ss>2)
            ss = 0
        end
        if (tt>2)
            tt = 0
        end
        println("Tst2 :", TT,ss,tt)

        # ======================================= 
        # Check for all possible Tst combinations & guarantee returning 1 of the match below:
        # ["N","t","tt","s","st","stt","ss","sst","sstt","N","Tt","Ttt","Ts","N","Tstt","Tss","ttss"]
        # ======================================= 
        Tst_val = TT*100 + ss*10 + tt
        indx = 1
    
        for x in 0:1
            for y in 0:2
                for z in 0:2
                    if( (x*100 + y*10 + z) == Tst_val) 
                        println(" got here....:", indx)
                        return Tst_string[indx]
                    end
                    indx += 1
                end
            end
    end

end
    # ======================================= 
    # check for possible matches - xpm + possible pairs and single x|m|p, etc.
    # ======================================= 
   
    if (xpm=='x' || xpm=='p' || xpm=='m') 

        for c in hand.cards 
            if(suit(inCard) == suit(c))
                s1 = string(c)[1] 
                if (s1 =='x')
                    xx+=1
                elseif (s1 =='p')
                    pp+=1
                elseif (s1 =='m')
                    mm+=1
                else
                    ;;
                end
            end
        end

        println("xpm1 :",xx,pp,mm)

        if (xx>2)
            xx = 0
        end
        if (pp>2)
            pp = 0
        end
        if (mm>2)
            mm = 0
        end

        println("xpm2 :",xx,pp,mm)

        xpm_val = xx*100 + pp*10 + mm
        indx = 1
        # Check for all possible Tst combinations & guarantee returning 1 of the match below:
        # ]"N","m","mm","p","pm","pmm","pp","ppm","ppmm","x","xm","xmm","xp","xmpp","xpp","xmmp","xmmpp","xx","xxm",
        # "xxmm","xxp","xxp","xxmpp","xxmm","xxmpp","xxmm","xxmmp","xxmmxx"]
        
        for x in 0:2
            for y in 0:2
                for z in 0:2
                    if( (x*100 + y*10 + z) == xpm_val) 
                        return xpm_string[indx]
                    end
                    indx += 1
                end
            end
        end

    end # end of checking xmp
   
    return ("N") # do nothing Tst/xpm/c's  in hand

end # end function



function tusacDeal()
    global gameDeck = shuffle!(Deck(full_deck()))
    global player1_hand = TuSacCards.Deck(pop!(gameDeck, 20))
    global player2_hand = TuSacCards.Deck(pop!(gameDeck, 20))
    TuSacCards.ssort(player1_hand)
    #println(player1_hand)

    for n in 1:20
        println(player1_hand)

        
        c = player1_hand.cards[n]
        (nhand, assets) = find_23ofakind(c::Card, player1_hand::Deck)
        println("Length of assets found: ", length(assets))
        ret_stat = find_groupTSTXPM(c::Card, player1_hand::Deck)

        println(ret_stat)
        readline()
    end

end