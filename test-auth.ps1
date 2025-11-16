# Simple Test - Auth Endpoints
# Run this after server is started with: npm run dev

Write-Host "Testing EduCourse Auth Endpoints..." -ForegroundColor Cyan
Write-Host ""

$baseUrl = "http://localhost:3000"

# Wait for server
Write-Host "[1] Checking server..." -ForegroundColor Yellow
Start-Sleep -Seconds 2

try {
    $root = Invoke-RestMethod -Uri "$baseUrl/" -Method GET
    Write-Host "✅ Server is running!" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "❌ Server not running. Start with: npm run dev" -ForegroundColor Red
    exit
}

# Test Register
Write-Host "[2] Testing POST /register..." -ForegroundColor Yellow
$randomId = Get-Random -Maximum 99999
$registerData = @{
    fullname = "Test User $randomId"
    username = "testuser$randomId"
    password = "password123"
    email = "test$randomId@example.com"
}

$registerBody = $registerData | ConvertTo-Json

try {
    $registerResult = Invoke-RestMethod -Uri "$baseUrl/register" -Method POST -Body $registerBody -ContentType "application/json"
    Write-Host "✅ Register Success!" -ForegroundColor Green
    Write-Host "   User ID: $($registerResult.id)" -ForegroundColor Gray
    Write-Host "   Message: $($registerResult.message)" -ForegroundColor Gray
} catch {
    $errorMsg = $_.Exception.Message
    if ($_.ErrorDetails.Message) {
        $errorDetail = $_.ErrorDetails.Message | ConvertFrom-Json
        Write-Host "❌ Register Failed: $($errorDetail.error)" -ForegroundColor Red
    } else {
        Write-Host "❌ Register Failed: $errorMsg" -ForegroundColor Red
    }
}

Write-Host ""

# Test Login
Write-Host "[3] Testing POST /login..." -ForegroundColor Yellow
$loginData = @{
    email = $registerData.email
    password = $registerData.password
}

$loginBody = $loginData | ConvertTo-Json

try {
    $loginResult = Invoke-RestMethod -Uri "$baseUrl/login" -Method POST -Body $loginBody -ContentType "application/json"
    Write-Host "✅ Login Success!" -ForegroundColor Green
    Write-Host "   Token: $($loginResult.token.Substring(0, [Math]::Min(50, $loginResult.token.Length)))..." -ForegroundColor Gray
    $token = $loginResult.token
} catch {
    $errorMsg = $_.Exception.Message
    if ($_.ErrorDetails.Message) {
        $errorDetail = $_.ErrorDetails.Message | ConvertFrom-Json
        Write-Host "❌ Login Failed: $($errorDetail.error)" -ForegroundColor Red
    } else {
        Write-Host "❌ Login Failed: $errorMsg" -ForegroundColor Red
    }
}

Write-Host ""

# Test Verify Email (will fail without real token from email)
Write-Host "[4] Testing GET /verify-email..." -ForegroundColor Yellow
Write-Host "⚠️  Skipped (requires token from email)" -ForegroundColor Yellow
Write-Host "   To test: GET /verify-email?token=YOUR_TOKEN" -ForegroundColor Gray

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Auth Endpoints Test Complete!" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
