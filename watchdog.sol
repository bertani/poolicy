contract MarklePath {
    event Log(string _tbl) anonymous;
    event Log_uint(uint _tbl) anonymous;
    event Log_data(bytes _data) anonymous;
    event Log_bytes64(uint256[2] _data) anonymous;
    event Log_bytes32(bytes32 _data) anonymous;
    event Log_bytes32_(byte[32] _data);
    
    function bytes32_to_bytes(bytes32 _a) returns (byte[32] _result){
        for (uint i=0; i<32; i++){
            _result[31-i] = bytes1(uint(_a) / uint(2**(i*8)));
        }
    }
    
    bool public _match;
    
    function checkProof(bytes proof) public returns (bool){
        //Log_uint(uint(msg.data[1]));
        //Log_uint(0);
        uint n = uint(proof[0]);
        byte[32] memory left;
        byte[32] memory right;
        
        byte RIGHT = byte(1);
        byte LEFT = byte(0);
        
        /*uint256[2] memory A;
        for (uint i=0; i<32; i++){
            A[0] += 48 * (2**(8*i));
        }
        A[1] = A[0];
        
        Log_bytes32(sha256(A));*/
        
        //Log_data(msg.data);
        Log_uint(1);
        for (uint i=0; i<32; i++){
            left[i] = proof[i+1];
            right[i] = proof[i+1];
        }
        
        Log_uint(2);
        
        for (uint j=0; j<n; j++){
            Log_uint(200+j);
            uint256[2] memory concat; //byte[64] memory concat;
            
            if(proof[(j+1)*(32+1)] == RIGHT) {
                Log_uint(50);
                
                
                for (i=0; i<32; i++){
                    concat[0] += uint(left[i]) * (2**(8*(31-i)));
                }
                for (i=0; i<32; i++){
                    concat[1] += uint(right[i]) * (2**(8*(31-i)));
                }
        
               /* for (i=0; i<64; i++){
                    if (i<32) concat[i] = left[i];
                    else concat[i] = right[i - 32];
                }*/
                Log_uint(60);
                Log_bytes64(concat);
                
                Log_bytes32(sha256(sha256(concat)));
                right = bytes32_to_bytes(sha256(sha256(concat)));
                Log_uint(70);
                for (i=0; i<32; i++) left[i] = proof[(j+1)*(32+1)+i];
            } else {
                Log_uint(51);
                
                /*for (i=0; i<64; i++){
                    if (i<32) concat[i] = right[i];
                    else concat[i] = left[i - 32];
                }*/
                
                
                for (i=0; i<32; i++){
                    concat[0] += uint(right[i]) * (2**(8*(31-i)));
                }
                for (i=0; i<32; i++){
                    concat[1] += uint(left[i]) * (2**(8*(31-i)));
                }
        
                
                Log_uint(60);
                Log_bytes64(concat);
                
                Log_bytes32(sha256(sha256(concat)));
                left = bytes32_to_bytes(sha256(sha256(concat)));
                Log_uint(70);
                for (i=0; i<32; i++) right[i] = proof[(j+1)*(32+1)+i];
            }
        }
        
        
        Log_bytes32_(left);
        for (i=0; i<32; i++){
            if (left[i] != proof[1+n*(32+1)+i]){
                _match = false;
                Log_uint(1000+i);
                return false;
            }
        }
        
        _match = true;
        Log_uint(100);
        return true;
    }
    
    mapping (address => uint) balances;
    
    
    function(){
        Log_uint(2000);
        if (msg.value > 0) msg.sender.send(msg.value);
    }
    
    function withdrawCollateral(uint _amount) public {
        
        Log_uint(2002);
        if (_amount > balances[msg.sender]) throw;
        msg.sender.send(_amount);
        balances[msg.sender] -= _amount;
    }
    
    function depositCollateral() public returns (bool){
        
        Log_uint(2001);
        if (msg.value == 0) throw;
        balances[msg.sender] += msg.value;
    }
    
    uint _lowerTxN;
    function redeemBounty(address _poolAddr, bytes _proof) public {
        
        Log_uint(2100);
        if (!checkProof(_proof)) return; //throw;
        
        Log_uint(2101);
        //TODO: check poolAddr sig matches getSig(_proof)
        uint n = uint(_proof[0]);
        if (n == 0) return; //throw;
        uint lowerTxN = 1+2**(n-1);
        _lowerTxN = lowerTxN;
        //if (lowerTxN > 64) throw;
        
        Log_uint(2102);
        msg.sender.send(balances[_poolAddr]);
        balances[_poolAddr] = 0;
        
        Log_uint(2103);
    }
    
    
}                                                                                                                                                                                                          
