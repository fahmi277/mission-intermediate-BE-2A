# Database Setup Script - PowerShell
# Auto-execute setup-database.sql

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "EduCourse Database Setup" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

$sqlFile = "setup-database.sql"
$mysqlPath = "mysql"

# Check if MySQL is in PATH
try {
    $null = Get-Command mysql -ErrorAction Stop
    Write-Host "✅ MySQL found in PATH" -ForegroundColor Green
} catch {
    Write-Host "❌ MySQL not found in PATH" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please add MySQL to PATH or use one of these methods:" -ForegroundColor Yellow
    Write-Host "1. phpMyAdmin - Copy paste setup-database.sql" -ForegroundColor Gray
    Write-Host "2. MySQL Workbench - Open and execute setup-database.sql" -ForegroundColor Gray
    Write-Host "3. Command: mysql -u root -p < setup-database.sql" -ForegroundColor Gray
    Write-Host ""
    Write-Host "See DATABASE-SETUP.md for detailed instructions" -ForegroundColor Cyan
    exit
}

Write-Host ""
Write-Host "This will setup the database with the new 'users' table" -ForegroundColor Yellow
Write-Host ""

# Ask for MySQL credentials
$username = Read-Host "MySQL Username (default: root)"
if ([string]::IsNullOrWhiteSpace($username)) {
    $username = "root"
}

$password = Read-Host "MySQL Password" -AsSecureString
$passwordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
)

Write-Host ""
Write-Host "Executing setup-database.sql..." -ForegroundColor Yellow

# Execute SQL file
try {
    if ([string]::IsNullOrWhiteSpace($passwordPlain)) {
        # No password
        Get-Content $sqlFile | & mysql -u $username
    } else {
        # With password
        Get-Content $sqlFile | & mysql -u $username "-p$passwordPlain"
    }
    
    Write-Host ""
    Write-Host "✅ Database setup completed!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Verifying tables..." -ForegroundColor Yellow
    
    # Verify
    $verifySQL = @"
USE educourse_db;
SHOW TABLES;
"@
    
    if ([string]::IsNullOrWhiteSpace($passwordPlain)) {
        $verifySQL | & mysql -u $username
    } else {
        $verifySQL | & mysql -u $username "-p$passwordPlain"
    }
    
    Write-Host ""
    Write-Host "==================================" -ForegroundColor Cyan
    Write-Host "Setup Complete! ✅" -ForegroundColor Green
    Write-Host "==================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Start server: npm run dev" -ForegroundColor Gray
    Write-Host "2. Test register: See MANUAL-TESTING.md" -ForegroundColor Gray
    
} catch {
    Write-Host ""
    Write-Host "❌ Error executing SQL:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "Alternative: Use phpMyAdmin or MySQL Workbench" -ForegroundColor Yellow
    Write-Host "See DATABASE-SETUP.md for instructions" -ForegroundColor Cyan
}
