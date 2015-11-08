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
    
    function (){
        //Log_uint(uint(msg.data[1]));
        //Log_uint(0);
        uint n = uint(msg.data[0]);
        byte[32] memory left;
        byte[32] memory right;
        
        byte RIGHT = byte(1);
        byte LEFT = byte(0);
        
        //Log_data(msg.data);
        Log_uint(1);
        for (uint i=0; i<32; i++){
            left[i] = msg.data[i+1];
            right[i] = msg.data[i+1];
        }
        
        Log_uint(2);
        
        for (uint j=0; j<n; j++){
            Log_uint(200+j);
            uint256[2] memory concat;
            
            if(msg.data[(j+1)*(32+1)] == RIGHT) {
                Log_uint(50);
                
                
            for (i=0; i<32; i++){
                concat[0] += uint(left[i]) * (2**(8*(31-i)));
            }
            for (i=0; i<32; i++){
                concat[1] += uint(right[i]) * (2**(8*(31-i)));
            }
        
                Log_uint(60);
                Log_bytes64(concat);
                
                Log_bytes32(sha256(sha256(concat)));
                right = bytes32_to_bytes(sha256(sha256(concat)));
                Log_uint(70);
                for (i=0; i<32; i++) left[i] = msg.data[(j+1)*(32+1)+i];
            } else {
                Log_uint(51);
                
                
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
                for (i=0; i<32; i++) right[i] = msg.data[(j+1)*(32+1)+i];
            }
        }
        
        
        Log_bytes32_(left);
        for (i=0; i<32; i++){
            if (left[i] != msg.data[n*(32+1)+i]){
                //_match = false;
                Log_uint(1000+i);
                return;
            }
        }
        
        _match = true;
        
        Log_uint(100);
    }
    
}                                                                                                                                                                                        
