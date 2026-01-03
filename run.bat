@echo off
echo Starting Crop Recommendation System...
echo.
echo Installing dependencies...
pip install -r requirements.txt
echo.
echo Starting Flask app...
echo App available at: http://localhost:5000
echo Press Ctrl+C to stop
echo.
python app.py
echo.
echo App stopped.
pause