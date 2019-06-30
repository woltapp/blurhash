using FluentAssertions;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Blurhash.Core.Test
{
    [TestClass]
    public class Base83Test
    {
        [TestMethod]
        public void EncodingTests()
        {
            1092.EncodeBase83(2).Should().BeEquivalentTo("DD");
            1092.EncodeBase83(4).Should().BeEquivalentTo("00DD");

            1337.EncodeBase83(2).Should().BeEquivalentTo("G9");
            1337.EncodeBase83(3).Should().BeEquivalentTo("0G9");

            83.EncodeBase83(2).Should().BeEquivalentTo("10");
            83.EncodeBase83(3).Should().BeEquivalentTo("010");
        }

        [TestMethod]
        public void EncodingSingleDigitsTests()
        {
            for (var i = 0; i < 83; i++)
            {
                i.EncodeBase83(1).Should().BeEquivalentTo(new string(Base83.Charset[i],1 ));
                i.EncodeBase83(2).Should().BeEquivalentTo(new string(new[] {'0', Base83.Charset[i]}));
            }
        }

        [TestMethod]
        public void DecodingTests()
        {
            "10".DecodeBase83Integer().Should().Be(83);
            "010".DecodeBase83Integer().Should().Be(83);

            "DD".DecodeBase83Integer().Should().Be(1092);
            "0DD".DecodeBase83Integer().Should().Be(1092);

            "G9".DecodeBase83Integer().Should().Be(1337);
            "0G9".DecodeBase83Integer().Should().Be(1337);
        }

        [TestMethod]
        public void DecodingSingleDigitsTest()
        {
            for (var i = 0; i < 83; i++)
            {
                new[] {Base83.Charset[i]}.DecodeBase83Integer().Should().Be(i);
                new[] {'0', Base83.Charset[i]}.DecodeBase83Integer().Should().Be(i);
            }
        }

    }
}
