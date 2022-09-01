# ========================================================
# stvo starts from here with functions to support TS game
# ========================================================
mutable struct ChotVDXT
    VDXT_Count::String
    match_Cards::String
    trash_Card::String
end

global TSArray  = ChotVDXT[]
global TSstArray = ChotVDXT[]
global TSxpmArray  = ChotVDXT[]


# check for 2, 3 and 4 of a kind from player_hand
function find_duplicate(inCard::Card, hand::Deck)

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

function find_TSTGroupCount(inCard::Card, hand::Deck) 
# 3 of a kind already checked prior to this logic
    TT = 0; ss = 0; tt = 0; xx = 0; pp = 0; mm = 0;
    
    Tst = xpm = string(inCard)[1]
    println("Current Card [" , inCard, "]")

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

        # ======================================= 
        # Check for all possible Tst combinations & guarantee returning 1 of the match below:
        # ["N","t","tt","s","st","stt","ss","sst","sstt","N","Tt","Ttt","Ts","N","Tstt","Tss","ttss"]
        # ======================================= 
        Tst_val = string(TT) * string(ss) * string(tt) # represent #'s Tst 
        return string(Tst_val)

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

        #println("stvo==> xpm-1 :",xx,pp,mm) # represent #'s xmp

        if (xx>2)
            xx = 0
        end
        if (pp>2)
            pp = 0
        end
        if (mm>2)
            mm = 0
        end

        #println("stvo==>xpm-2 :",xx,pp,mm)

        xpm_val = string(xx) * string(pp) * string(mm) # represent #'s Tst 
        return string(xpm_val)
       
    end # end of checking xmp

    # Check for possible combinations of c's 

    VV=XX=DD=TT=0
    if ((Tst=='c'))

        for c in hand.cards 
            s1 = string(c)
            if(s1[1] == 'c')
                if(s1[2] == 'V')
                    VV += 1
                elseif(s1[2] == 'D')
                    DD += 1
                elseif(s1[2] == 'X')
                    XX += 1
                elseif(s1[2] == 'T')
                    TT += 1
                else
                    ;;
                end
            end
        end
    
        if (VV>2)
            VV = 0
        end
        if (XX>2)
            XX = 0
        end
        if (DD>2)
            DD = 0
        end
        if (TT>2)
            TT = 0
        end

        ccc_val = string(VV) * string(XX) * string(DD) * string(TT) # represent #'s Tst 
        return string(ccc_val)
    end

    return("0000") # do nothing Tst/xpm/c's  in hand
   

end # end function

# Read TS look up file 
function readTSFile(fileName::String)

    TSArray = ChotVDXT[]
   
    f = open(fileName, "r")
    s = readline(f)  # skip the comment line in a file
    while ! eof(f) 
       
        s = readline(f)       
        ss = (split("$s", "|"))  
        tmp = ChotVDXT( ss[1],  ss[2],  ss[3])
        push!(TSArray, tmp)
    end
    close(f)
    return (TSArray)
end

  
function swapchars(ss::String, i::Int, j::Int)

    # swap position for t from s or to current chot suit 
    # the look up files only apply for si & chot vang
    ret_string = ""
    str = collect(ss)
    str[i],str[j] = str[j],str[i] 

    for (i, v) in enumerate(str)
        ret_string = ret_string*string(v)       
    end
  
    return(ret_string)
end
function find_match_TSArray(ret_stat::String, thisArray::Vector{ChotVDXT})
    #println("stvo find_match_TSArray... in restat: ", ret_stat)
    for (ind, line) in enumerate(thisArray)
        #println("[", ind,"] ",line)
        if(line.VDXT_Count == ret_stat)
            #println("stvo==> index found in TSArray: ", ind)
            return ind
        end
    end
    return (0)
end

function getTestCards()
    # save a test set Tstxcpm of each color to test if the player
    # wins when he has no trash cards

    deck = TuSacCards.Deck(full_deck())
    tmpCards = Any[]
    for index in 1:112
        if(mod(index,27) == 0)
            for nn in 1:7 
                mm = (index+nn-27)
                push!(tmpCards, deck.cards[mm])
            end
        end
    end
    #println(saveCards)
    return (tmpCards)
end

function stvoClientSim()

    # ============================================================
    # for intergration stvoClientSim() needs to only passing 
    # the current hand and a current card
    # function stvoClientSim(curentCard::Card, player_hand::Deck)
    # ============================================================

    global gameDeck = shuffle!(Deck(full_deck()))
    global player1_hand = TuSacCards.Deck(pop!(gameDeck, 20))
    global player2_hand = TuSacCards.Deck(pop!(gameDeck, 20))
    global TStestCards = getTestCards()

    TuSacCards.ssort(player1_hand) # for easy to see all the cards 

    global TScArray   = ChotVDXT[] # array of roles and columns from a TS_cText.file
    global TSstArray  = ChotVDXT[] # array of roles and columns from a TSstText.txt file
    global TSxpmArray = ChotVDXT[] # array of roles and columns from a TS_xpmText.file


    # Read inputs from files once
    TSstArray  = readTSFile("TS_stText.txt")
    TSxpmArray = readTSFile("TS_xpmText.txt")
    TScArray   = readTSFile("TS_cText.txt")

      # Note: The loop here is to test each of 20 cards from player1_hand2 
      # with player_hand1 holding - The loop only work once unless you comment
      # out all the return statement from this funtion because the return will
      # break out the loop and exit the function. 
      for n in 1:20
        println(player1_hand)
        global ret_stat="0"
        global ii, jj, trash_Card, match_Cards, TSxpmArray
       
        println(player1_hand)

        #curCard = player1_hand.cards[n] selftest
        curCard = player2_hand.cards[n]

        (nhand, assets) = find_duplicate(curCard::Card, player1_hand::Deck)

        #println("Length of assets found: ", string(curCard), " ", length(assets))

        if(length(assets) == 3) 
            ss = string(curCard)[1]
            match_Cards = ss*ss*ss*ss
            ret_stat = match_Cards
            trash_Card  = "N"
            return (match_Cards, trash_Card)
        end
               
        ret_stat = find_TSTGroupCount(curCard::Card, player1_hand::Deck)

        println("stvo ==> #'s TSTMPMC [", ret_stat, "]")

        # Check for Tst combinations 
        # 000 001 002 010 011 012 020 021 022 100 101 102 110 111 112 120 121 122
        if(string(curCard)[1] == 'T') ## T is current card
            if(ret_stat[1] == '1') # if T is subset of Tst/Tsst/Ttts (Same T is already in hand)
                #println("stvo ==> T is subset of Tst from hand: ", ret_stat)
                match_Cards = "NNN"
                trash_Card  = "N"
            else
                if(ret_stat == "011") 
                    match_Cards = "TST"
                    trash_Card  = "N"
                else
                    match_Cards = "NNN"
                    trash_Card  = "N"
                end
            end
            return (match_Cards, trash_Card)
        end
      
        if(string(curCard)[1] == 's' || string(curCard)[1] == 't') ## s is current card
            global match_Cards, trash_Card
            index = find_match_TSArray(ret_stat, TSstArray) 
            
            if(index == 0)
                #println("stvo==> (st) No match found in file.....", string(curCard))
                match_Cards = "NNN"
                trash_Card  = "N"
                return(match_Cards, trash_Card)               
            else
                #println("stvo==> index found in file.....", index, " ", TSstArray[index])
                match_Cards = TSstArray[index].match_Cards
                trash_Card  = TSstArray[index].trash_Card
                #println("stvo==> (s) actual_match :", match_Cards, "|", trash_Card)
                return(match_Cards, trash_Card)
            end
           
           #return (index) stvo remember to return in actual code
        end
        
        if(string(curCard)[1] == 't') ## s is current card
            tmp_stat = TSstArray[index].VDXT_Count
            new_stat = swapchars(tmp_stat,2,3) # swap logic for t 
            index = find_match_TSArray(new_stat, TSstArray)
            match_Cards = TSstArray[index].match_Cards
            trash_Card = TSstArray[index].trash_Card

            match_Cards = replace(match_Cards, "S" => "T", "T" => "S")
            trash_Card = replace(trash_Card, "T" => "S")
           
            return (match_Cards, trash_Card)
        end
        
        # check for xe combinations
        ## 000 001 002 010 011 012 020 021 022 100 101 102 110 111 
        ## 112 120 121 122 200 201 202 210 211 212 220 221 222 
        if(string(curCard)[1] == 'x' || string(curCard)[1] == 'p'|| string(curCard)[1] == 'm')
            index = find_match_TSArray(ret_stat, TSxpmArray) 
            # println("stvo==> current card(xmp) : ",string(curCard), " ", ret_stat)
            # println("stvo==> (xpm) )", index, " ", TSxpmArray[index])
           
            if(index == 0)
                println("stvo==> No match found in file.....")
                match_Cards = "N"
                trash_Card  = "N"
                return (match_Cards, trash_Card)
            end
        end
        
        if(string(curCard)[1] == 'x') 
            #println("stvo==> index found in file.....", index, " ", TSxpmArray[index])
            match_Cards = TSxpmArray[index].match_Cards
            trash_Card  = TSxpmArray[index].trash_Card
            return (match_Cards, trash_Card)
        end

        # check for phao combinations
        if(string(curCard)[1] == 'p') 
            global index
            tmp_stat = TSxpmArray[index].VDXT_Count
            new_stat = swapchars(tmp_stat,1,2) # swap logic for p from x position in the look up file 
            index = find_match_TSArray(new_stat, TSxpmArray)
            match_Cards = TSxpmArray[index].match_Cards
            trash_Card = TSxpmArray[index].trash_Card

            match_Cards = replace(match_Cards, "P" => "X", "X" => "P")
            trash_Card = replace(trash_Card, "P" => "X")
            #println("stvo==> actual_match :", match_Cards, "|", trash_Card)
            return (match_Cards, trash_Card)
           
        end

        # check for ma combinations
        if(string(curCard)[1] == 'm') 
            global index
            global TSxpmArray
            tmp_stat = TSxpmArray[index].VDXT_Count
            new_stat = swapchars(tmp_stat,1,3) # swap logic for p from x position in the look up file 
            index = find_match_TSArray(new_stat, TSxpmArray)
            match_Cards = TSxpmArray[index].match_Cards
            trash_Card = TSxpmArray[index].trash_Card

            match_Cards = replace(match_Cards, "M" => "X", "X" => "M")
            trash_Card = replace(trash_Card, "M" => "X")
            #println("stvo==> actual_match :", match_Cards, "|", trash_Card)
            return (match_Cards, trash_Card)
           
        end

        # check for chot's combinations (VDXT)
        # standard code for to handle cV in yellow therefore we need to swap the position 
        # to get the match with current suit other than yellow
        # when the current card is other than cV 
        if(string(curCard)[1] == 'c') 
            global ii = 1; jj = 2
            global trash_Card, match_Cards
            index = find_match_TSArray(ret_stat, TScArray) 
            #println("stvo==>", ret_stat, " found in file at: ", index)
            if(index == 0)
                match_Cards = "N"
                trash_Card  = "N"
                return (match_Cards, trash_Card)
            else
                # chot vang matched by lookup up from a file as default
                match_Cards = TScArray[index].match_Cards
                trash_Card = TScArray[index].trash_Card
                if(string(curCard)[2] != 'V')
                    return (match_Cards, trash_Card)
                end
            end
           
            if(string(curCard)[2] != 'V')
                if(string(curCard)[2] == 'X') 
                    ii = 1; jj = 2
                    cColor = "X"
                elseif(string(curCard)[2] == 'D')
                    ii = 1; jj = 3
                    cColor = "D"
                elseif(string(curCard)[2] == 'T')
                    ii = 1; jj = 4
                    cColor = "T"
                else
                    ;;
                end
                println("stvo==> swap chot's indices...", string(curCard),"indices: ", ii, jj)
                tmp_stat = TScArray[index].VDXT_Count
                new_stat = swapchars(tmp_stat,ii,jj)
                #println("stvo==> new_Stat:", new_stat)
                # The test card must be chot vang (cV)
                index = find_match_TSArray(new_stat, TScArray)
                println("stvo==>", new_stat, " found in file at: ", index, " ", TScArray[index])
                match_Cards = TScArray[index].match_Cards
                trash_Card  = TScArray[index].trash_Card
                println("stvo==> B4 actual_match :", match_Cards, "|", trash_Card, " ", cColor)

                match_Cards = replace(match_Cards, "V" => cColor, cColor => "V")
                trash_Card = replace(trash_Card, cColor => "V")

                return (match_Cards, trash_Card)
              
            end

            #return # return for now testing stvo
        end
        
        #println(ret_stat)
        #readline()

    end # end of loop 20-card test set

end # end stvoClientSim

(matchCards, trasCard) = stvoClientSim()
println("stvo ==> stvoClientSim() ", matchCards, "|", trasCard)
