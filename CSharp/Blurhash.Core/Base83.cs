using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;

namespace Blurhash.Core
{
    /// <summary>
    /// Contains methods to encode or decode integers to Base83-Strings
    /// </summary>
    public static class Base83
    {
        internal const string Charset = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz#$%*+,-.:;=?@[]^_{|}~";

        private static readonly IReadOnlyDictionary<char, BigInteger> ReverseLookup;

        static Base83()
        {
            // Build inverse lookup table for fast decoding
            var charIndices = new Dictionary<char, BigInteger>();
            var index = 0;
            foreach (var c in Charset)
            {
                charIndices[c] = index;
                index++;
            }

            ReverseLookup = charIndices;
        }

        /// <summary>
        /// Encodes a number into its Base83-representation
        /// </summary>
        /// <param name="number">The number to encode</param>
        /// <param name="length">The length of the Base83-string</param>
        /// <returns>The Base83-representation of the number</returns>
        public static string EncodeBase83(this BigInteger number, int length)
        {
            var result = new char[length];
            foreach (var i in Enumerable.Range(1, length))
            {
                var digit = (int)((number / BigInteger.Pow(83,length - i)) % 83);
                result[i - 1] = Charset[digit];
            }

            return new string(result);
        }

        /// <summary>
        /// Encodes a number into its Base83-representation
        /// </summary>
        /// <param name="number">The number to encode</param>
        /// <param name="length">The length of the Base83-string</param>
        /// <returns>The Base83-representation of the number</returns>
        public static string EncodeBase83(this int number, int length)
        {
            return ((BigInteger) number).EncodeBase83(length);
        }

        /// <summary>
        /// Decodes an <code>IEnumerable</code> of Base83-characters into the integral value it represents
        /// </summary>
        /// <param name="base83Data">The characters to decode</param>
        /// <returns>The decoded value as integer</returns>
        public static BigInteger DecodeBase83Integer(this IEnumerable<char> base83Data)
        {
            var characters = base83Data as char[] ?? base83Data.ToArray();

            if (!characters.IsBase83String())
                throw new ArgumentException("The given string contains invalid characters.", nameof(base83Data));

            var result = (BigInteger)0;
            foreach (var c in characters)
            {
                var digit = ReverseLookup[c];
                result *= 83;
                result += digit;
            }

            return result;
        }

        /// <summary>
        /// Checks whether a given String is a valid Base83-String.
        /// </summary>
        /// <param name="stringToCheck">The string to check</param>
        /// <returns><code>true</code>, if the string only contains valid Base83-characters; <code>false</code> otherwise</returns>
        public static bool IsBase83String(this IEnumerable<char> stringToCheck)
        {
            // The string is a Base83 string, when all chars are contained in the inverse lookup table
            return stringToCheck.All(ReverseLookup.ContainsKey);
        }
    }
}
