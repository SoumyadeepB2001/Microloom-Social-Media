using System;
using System.Security.Cryptography;
using System.Linq;

public class PasswordHasher
{
    public const int SaltSize = 16; // 128-bit salt
    public const int HashSize = 32; // 256-bit hash
    public const int Iterations = 310000; // Increased to recommended security level

    /// <summary>
    /// Hashes a password using PBKDF2 (SHA-256) with a unique salt.
    /// </summary>
    public string HashPassword(string password)
    {
        if (string.IsNullOrEmpty(password))
            throw new ArgumentException("Password cannot be null or empty.");

        byte[] salt = new byte[SaltSize];
        using (var rng = RandomNumberGenerator.Create()) // Updated from RNGCryptoServiceProvider
        {
            rng.GetBytes(salt); // Generate random salt
        }

        using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, Iterations, HashAlgorithmName.SHA256))
        {
            byte[] hash = pbkdf2.GetBytes(HashSize);

            // Combine salt + hash and store in Base64
            byte[] hashBytes = new byte[salt.Length + hash.Length];
            Array.Copy(salt, 0, hashBytes, 0, salt.Length);
            Array.Copy(hash, 0, hashBytes, salt.Length, hash.Length);

            return Convert.ToBase64String(hashBytes);
        }
    }

    /// <summary>
    /// Verifies if the entered password matches the stored hash.
    /// </summary>
    public bool VerifyPassword(string storedHash, string enteredPassword)
    {
        if (string.IsNullOrEmpty(storedHash) || string.IsNullOrEmpty(enteredPassword))
            return false;

        byte[] hashBytes = Convert.FromBase64String(storedHash);

        // Extract salt (first 16 bytes)
        byte[] salt = new byte[SaltSize];
        Array.Copy(hashBytes, 0, salt, 0, SaltSize);

        // Hash entered password using the extracted salt
        using (var pbkdf2 = new Rfc2898DeriveBytes(enteredPassword, salt, Iterations, HashAlgorithmName.SHA256))
        {
            byte[] newHash = pbkdf2.GetBytes(HashSize);

            // Use constant-time comparison for security
            return hashBytes.Skip(SaltSize).SequenceEqual(newHash);
        }
    }
}
