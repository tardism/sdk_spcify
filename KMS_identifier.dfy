method ValidAwsKmsIdentifier(str : string) returns (res : bool) 
{
    var count_colon := 0;
    var hi := |str|;
    var j := 0;
    res := true;
    
    if (hi<5){
        return false;
    }
    var secondCol, thirdCol, fourthCol,fifthCol := 0, 0, 0, 0;

    while (j <hi){
        if (str[j] == ':'){
            count_colon := count_colon+1;

            if(count_colon == 2){
                secondCol := j; 
            }

            else if(count_colon == 3){
                thirdCol := j;
            }

            else if(count_colon == 4){
                fourthCol := j;
            }

            else if(count_colon == 5){
                fifthCol := j;
            }

            if (count_colon>5){
            return false;
            }
            
        }
        j:= j+1;
    }

    if (count_colon != 5 && str[0:3] != [['a','r','n']]){
        return false;  
    }
    if(str[4]==':'){
        return false;
    }
    

    if((secondCol<thirdCol<|str| )&& (str[secondCol:thirdCol]) != [['k','m','s']]){
        return false;
    }

    if(fourthCol-thirdCol<2){
        return false;
    }

    
}