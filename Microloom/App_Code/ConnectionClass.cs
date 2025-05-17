using System.Configuration;
using System.Data.SqlClient;

public class ConnectionClass
{
    public string strConnectionString;
    public SqlCommand _sqlCommand;
    public ConnectionClass()
    {
        strConnectionString = ConfigurationManager.ConnectionStrings["connection1"].ConnectionString;
    }

    public void CreateConnection()
    {
        SqlConnection _sqlConnection = new SqlConnection(strConnectionString);
        _sqlCommand = new SqlCommand();
        _sqlCommand.Connection = _sqlConnection;
    }

    public void OpenConnection()
    {
        _sqlCommand.Connection.Open();
    }

    public void CloseConnection()
    {
        _sqlCommand.Connection.Close();
    }

    public void DisposeConnection()
    {
        _sqlCommand.Connection.Dispose();
    }
}