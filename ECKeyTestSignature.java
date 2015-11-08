package org.ethereum.crypto;

import org.apache.commons.codec.binary.Base64;
import org.ethereum.crypto.ECKey.ECDSASignature;
import org.junit.Test;
import org.spongycastle.util.encoders.Hex;

public class ECKeyTestSignature {

    @Test
    public void testSigning() throws Exception {
        final String privKey = "eab5f6141b4c66877f178f8b87c804d380af6d5404edc249d2c388dbcc542977";
        final String hashToSign = "58e2f335bbd6f2b0da93eae19342e7309654fbfeed9a214a1e5d835ac09cc226";

        final ECKey key = ECKey.fromPrivate(Hex.decode(privKey));
        System.out.println("eth address= " + bytesToHex(key.getAddress()));  // 31031df1d95a84fc21e80922ccdf83971f3e755b
        byte[] hashToSignBytes=Hex.decode(hashToSign);
        System.out.println("hash to sign= " + hashToSign); //58e2f335bbd6f2b0da93eae19342e7309654fbfeed9a214a1e5d835ac09cc226

        final ECDSASignature sign = key.sign(hashToSignBytes);
        final String x1 = sign.toBase64();
        byte[] valueDecoded1= Base64.decodeBase64(x1);
        System.out.println("Base64 signature " + bytesToHex(valueDecoded1)); //200b7effb7704f726bc64139753dc2d0a3929af2309dd2930ad7a722f5b214cf6e73a461ce418e9e483f13a98c0cba5cddf07f647ea1d6ba2e88d494dfcd411c9c

        byte[] rBytes = sign.r.toByteArray();
        System.out.println("r " + bytesToHex(rBytes)); //0b7effb7704f726bc64139753dc2d0a3929af2309dd2930ad7a722f5b214cf6e

        byte[] sBytes = sign.s.toByteArray();
        System.out.println("s " + bytesToHex(sBytes)); //73a461ce418e9e483f13a98c0cba5cddf07f647ea1d6ba2e88d494dfcd411c9c

        byte[] vBytes = new byte[1];
        vBytes[0] = sign.v;
        System.out.println("v " + bytesToHex(vBytes)); //20
    }



    public static String bytesToHex(byte[] in) {
        final StringBuilder builder = new StringBuilder();
        for(byte b : in) {
            builder.append(String.format("%02x", b));
        }
        return builder.toString();
    }
}
