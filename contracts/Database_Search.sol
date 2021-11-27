 pragma solidity ^0.5.0;
     pragma experimental ABIEncoderV2;
contract Database_Search{
    
     struct user{
        string username;
        string password;
        
    }
        user[] public users;
       mapping(string => mapping(string => Index_details)) details;
       
    struct Index_details{
     uint flag;
     string key;
   //  mapping(string=>string)Index;
     string[] Index;
    }
    
    function Register(string memory username,string memory password) public{
           uint i=findd_id(username);
           if(i==0){
               users.push(user(username,password));
           }
           else{
               revert('The username already exists! ');
           }
                  
    }
    
    function Insert(string memory username,string memory password,string memory tablename,string memory Key,string [] memory input) public{
        uint i=find_id(username);
         if(keccak256(abi.encodePacked(users[i].password))== keccak256(abi.encodePacked(password)))
         {
          if(details[username][tablename].flag==0){
              if(input.length%2!=0)
              {
                  revert('The index table is wrong/Incomplete ! ');
              }
              Index_details memory p;
              p.flag=1;
              p.key=Key;
            /*  string memory k;
              string memory v;
               for(uint i=0;i<input.length;i+=2){
                   k=input[i];
                   v=input[i+1];
                   p.Index[k]=v;
            } */
            p.Index=input;
              details[username][tablename]=p;
          }   
          else{
               revert('The tablename for username already exists! ');
          }
         }
         else{
             revert(' Wrong Password for username !');
         }
         
    }
    
    function Search_Keyword(string memory username, string memory tablename,string memory Enc_keyword)view public returns(string memory,string memory){
         uint i=find_id(username);
          if(details[username][tablename].flag!=0){
             uint j=find_id_in_index(Enc_keyword,details[username][tablename].Index);
             if(j==details[username][tablename].Index.length-1){
                  revert('The Enc_Keyword does not exist in username->tablename ! ');
             }
             return (details[username][tablename].Index[j],details[username][tablename].Index[j+1]);
              
          }   
          else{
               revert('The tablename for username already exists! ');
          }
         
    }
    
    
     function find_id(string memory username)view internal returns(uint){
            for(uint i=0;i<users.length;i++){
                if(keccak256(abi.encodePacked(users[i].username))== keccak256(abi.encodePacked(username)))
                {
                    return i;
                }
            }
            revert('This username does not exist !');
        }
        
    function find_id_in_index(string memory Enc_Keyword,string [] memory str)view internal returns(uint){
            for(uint i=0;i<str.length;i++){
                if(keccak256(abi.encodePacked(str[i]))== keccak256(abi.encodePacked(Enc_Keyword)))
                {
                    return i;
                }
            }
             revert('The Enc_Keyword does not exist in username->tablename ! ');
        }
    
    function findd_id(string memory username)view internal returns(uint){
             uint k=0;
            for(uint i=0;i<users.length;i++){
                if(keccak256(abi.encodePacked(users[i].username))== keccak256(abi.encodePacked(username)))
                {
                     k=1;
                }
            }
            return k;
           
        }
    
    
    
    
    
    
    
}