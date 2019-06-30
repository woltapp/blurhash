# Usage

# Projects in this solution
This list does not contain the projects with names ending in `.Test` as they are the test projects for the ones listed here.

- Blurhash.Core
  The core algorithm of blurhash. For maximum compatibility this is a .NET-Standard project.
- System.Drawing.Blurhash.DotNetFramework
  Bridge-Library to use Blurhash with the System.Drawing namespace of the .NET-Framework.
  This is only available in Windows projects as it uses GDI+
- System.Drawing.Blurhash.DotNetStandard
  Bridge-Library to use Blurhash with the System.Drawing.Common NuGet-Library in .NET-Standard
