
@enum TS_PAIRS begin
    t_PAIR = 1
    s_PAIR = 2
    x_PAIR = 3
    p_PAIR = 4
    c_PAIR = 5
    s_MATCH = 6
    t_MATCH = 7
    ts_MATCH = 8
    st_MATCH = 9
    x_MATCH = 10
    p_MATCH = 11
    m_MATCH = 12
    xp_MATCH = 13
    xm_MATCH = 14
    pm_MATCH = 15
    NONE_MATCH = 16
end


function show_deck(deck::Deck)
    for x in deck
        print(Card[x], " Suit:[", suit(x), " ] Rank: ", rank(x), "] Value:", x.value,"\n")
    end
end


# check for 2, 3 and 4 of a kind from player_hand
function find_duplicate(inCard::Card, hand::Deck)

    player_newhand = Any[] # new hand after matched cards being removed
    player_assets = Any[] # player's assets card needs to be added to the "pile"
    println("Card: ", inCard, " \nhand:",hand)
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
    
    Tst = string(inCard)[1]
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
    end
    println("stT :", TT,ss,tt)
    # check for possible matches - Tst/Ts/Tt/ts + 1s/2t;1s/0t;2s/1t & 1t/0s, etc.

    if (ss == tt == 1 && TT > 0) 
        return (NONE_MATCH) # do nothing Tst are in hand
    end
    if(ss == 1 && tt == 0) 
        return (s_MATCH) # s alone
    end
    if(ss == 0 && tt == 1 && TT == 0) 
        return (s_MATCH) # t alone
    end
    if(ss == 0 && tt == 1 && TT > 0) 
        return (st_MATCH) # t alone
    end
    if ((ss==1 && tt>=2) || (ss==1 && tt==0)) return (s_MATCH) # s alone
        elseif ((ss>=2 && tt==1) || (ss==0 && tt==1)) return (t_MATCH) # t alone
        elseif (tt == 1 && ss == 1) return (ts_MATCH)
        else
       ;;
    end

    # check for possible matches - xpm + possible pairs and single x|m|p, etc.

    if (Tst=='x' || Tst=='p' || Tst=='m') 
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
    end

    println("stT :",xx,pp,mm)

    if ( (xx>= 2 &&  pp>= 2 && mm>= 2) || ( xx>= 2 &&  pp>= 2  && mm==0))
        return (NONE_MATCH)
    end
    if ( xx>= 2 &&  pp>= 2  && pp==1) return (m_MATCH)
        elseif (xx>= 2 &&  pp>=1  && mm==2) return (p_MATCH)
        elseif (xx>= 2 &&  pp>=1  && mm==1) return (x_MATCH)
        elseif (xx>= 2 &&  pp>=1  && mm==0) return (p_MATCH)
        elseif (xx>= 2 &&  pp>=0  && mm==0) return (NONE_MATCH)
        elseif (xx>= 1 &&  pp>=2  && mm==2) return (x_MATCH)
        elseif (xx>= 1 &&  pp>=2  && mm==1) return (p_MATCH)
        elseif (xx>= 1 &&  pp>=2  && mm==0) return (x_MATCH)
        elseif (xx>= 1 &&  pp>=1  && mm==2) return (m_MATCH)
        elseif (xx>= 2 &&  pp>=1  && mm==0) return (NONE_MATCH)
        elseif (xx>= 1 &&  pp>=1  && mm==0) return (xp_MATCH)
        elseif (xx>= 0 &&  pp>=2  && mm==2) return (NONE_MATCH)
        elseif (xx>= 0 &&  pp>=2  && mm==1) return (m_MATCH)
        elseif (xx>= 0 &&  pp>=1  && mm==2) return (p_MATCH)
        elseif (xx>= 0 &&  pp>=1  && mm==1) return (xm_MATCH)
        elseif (xx>= 0 &&  pp>=1  && mm==0) return (m_MATCH)
        else
            ;;
    end
   
    return (NONE_MATCH) # do nothing Tst are in hand
end # end function


