# Test Script - EduCourse Backend API
# Script PowerShell untuk testing semua endpoint

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "EduCourse Backend API Test Script" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

$baseUrl = "http://localhost:3000"

# Test 1: Check if server is running
Write-Host "[1] Testing Server..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/" -Method GET
    Write-Host "✅ Server is running!" -ForegroundColor Green
    Write-Host $response.message -ForegroundColor Gray
} catch {
    Write-Host "❌ Server is not running. Please start with 'npm run dev'" -ForegroundColor Red
    exit
}

Write-Host ""

# Test 2: Register User
Write-Host "[2] Testing Register..." -ForegroundColor Yellow
$registerBody = @{
    fullname = "Test User"
    username = "testuser" + (Get-Random -Maximum 9999)
    password = "password123"
    email = "test" + (Get-Random -Maximum 9999) + "@example.com"
} | ConvertTo-Json

try {
    $registerResponse = Invoke-RestMethod -Uri "$baseUrl/register" -Method POST -Body $registerBody -ContentType "application/json"
    Write-Host "✅ Register Success!" -ForegroundColor Green
    Write-Host "User ID: $($registerResponse.id)" -ForegroundColor Gray
    $testEmail = ($registerBody | ConvertFrom-Json).email
} catch {
    Write-Host "❌ Register Failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Test 3: Login
Write-Host "[3] Testing Login..." -ForegroundColor Yellow
$loginBody = @{
    email = $testEmail
    password = "password123"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "$baseUrl/login" -Method POST -Body $loginBody -ContentType "application/json"
    Write-Host "✅ Login Success!" -ForegroundColor Green
    Write-Host "Token: $($loginResponse.token.Substring(0, 50))..." -ForegroundColor Gray
    $token = $loginResponse.token
} catch {
    Write-Host "❌ Login Failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Test 4: Get Courses (without auth)
Write-Host "[4] Testing GET /course..." -ForegroundColor Yellow
try {
    $courses = Invoke-RestMethod -Uri "$baseUrl/course" -Method GET
    Write-Host "✅ Get Courses Success!" -ForegroundColor Green
    Write-Host "Total courses: $($courses.Count)" -ForegroundColor Gray
} catch {
    Write-Host "❌ Get Courses Failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Test 5: Get Courses with Filter
Write-Host "[5] Testing GET /course with filter..." -ForegroundColor Yellow
try {
    $filteredCourses = Invoke-RestMethod -Uri "$baseUrl/course?kategori_id=1&sortBy=harga" -Method GET
    Write-Host "✅ Filter Success!" -ForegroundColor Green
    Write-Host "Filtered courses: $($filteredCourses.Count)" -ForegroundColor Gray
} catch {
    Write-Host "❌ Filter Failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Test 6: Get Courses with Search
Write-Host "[6] Testing GET /course with search..." -ForegroundColor Yellow
try {
    $searchCourses = Invoke-RestMethod -Uri "$baseUrl/course?search=node" -Method GET
    Write-Host "✅ Search Success!" -ForegroundColor Green
    Write-Host "Search results: $($searchCourses.Count)" -ForegroundColor Gray
} catch {
    Write-Host "❌ Search Failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Test 7: Get Course by ID
Write-Host "[7] Testing GET /course/:id..." -ForegroundColor Yellow
try {
    $course = Invoke-RestMethod -Uri "$baseUrl/course/1" -Method GET
    Write-Host "✅ Get Course by ID Success!" -ForegroundColor Green
    Write-Host "Course: $($course.nama_kelas)" -ForegroundColor Gray
} catch {
    Write-Host "⚠️  No course found (this is OK if database is empty)" -ForegroundColor Yellow
}

Write-Host ""

# Test 8: Create Course (without auth)
Write-Host "[8] Testing POST /course..." -ForegroundColor Yellow
$courseBody = @{
    nama_kelas = "Test Course"
    deskripsi = "Test Description"
    harga = 100000
    kategori_id = 1
    tutor_id = 1
} | ConvertTo-Json

try {
    $createResponse = Invoke-RestMethod -Uri "$baseUrl/course" -Method POST -Body $courseBody -ContentType "application/json"
    Write-Host "✅ Create Course Success!" -ForegroundColor Green
    Write-Host $createResponse.message -ForegroundColor Gray
} catch {
    Write-Host "⚠️  Create Failed (might need auth or missing kategori/tutor)" -ForegroundColor Yellow
}

Write-Host ""

# Test 9: Test with Auth Header
Write-Host "[9] Testing with Authentication..." -ForegroundColor Yellow
if ($token) {
    $headers = @{
        "Authorization" = "Bearer $token"
    }
    
    try {
        $authResponse = Invoke-RestMethod -Uri "$baseUrl/course" -Method GET -Headers $headers
        Write-Host "✅ Authentication works!" -ForegroundColor Green
        Write-Host "Courses with auth: $($authResponse.Count)" -ForegroundColor Gray
    } catch {
        Write-Host "❌ Auth Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "⚠️  No token available, skipping auth test" -ForegroundColor Yellow
}

Write-Host ""

# Test 10: Upload (requires actual file)
Write-Host "[10] Testing Upload..." -ForegroundColor Yellow
Write-Host "⚠️  Skipped (requires actual file path)" -ForegroundColor Yellow
Write-Host "To test upload, use:" -ForegroundColor Gray
Write-Host '$filePath = "C:\path\to\image.jpg"' -ForegroundColor Gray
Write-Host '$formData = @{ file = Get-Item -Path $filePath }' -ForegroundColor Gray
Write-Host 'Invoke-RestMethod -Uri "http://localhost:3000/upload" -Method POST -Form $formData' -ForegroundColor Gray

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Test Complete!" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📚 For more tests, check:" -ForegroundColor Green
Write-Host "   - API-TESTING.md" -ForegroundColor Gray
Write-Host "   - IMPLEMENTATION-GUIDE.md" -ForegroundColor Gray
Write-Host "   - QUICK-START.md" -ForegroundColor Gray
