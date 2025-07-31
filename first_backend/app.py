from flask import Flask, request, jsonify
import os
import face_recognition
import datetime
from werkzeug.utils import secure_filename

app = Flask(__name__)

REGISTER_FOLDER = "faces"
TEMP_FOLDER = "temp"

os.makedirs(REGISTER_FOLDER, exist_ok=True)
os.makedirs(TEMP_FOLDER, exist_ok=True)

@app.route("/register", methods=["POST"])
def register_face():
    if 'image' not in request.files or 'name' not in request.form or 'empId' not in request.form:
        return jsonify({'error': 'Missing fields'}), 400

    image = request.files['image']
    name = request.form['name']
    empId = request.form['empId']

    # Save and verify image
    temp_path = os.path.join(TEMP_FOLDER, "check.jpg")
    image.save(temp_path)
    img = face_recognition.load_image_file(temp_path)
    encodings = face_recognition.face_encodings(img)
    if not encodings:
        return jsonify({'error': 'No face detected in uploaded image'}), 400

    filename = f"{empId}_{secure_filename(name)}.jpg"
    save_path = os.path.join(REGISTER_FOLDER, filename)
    image.save(save_path)

    return jsonify({'message': 'Face registered successfully'}), 200

@app.route("/recognize", methods=["POST"])
def recognize_face():
    if 'image' not in request.files:
        print("[ERROR] No image provided")
        return jsonify({'error': 'No image provided'}), 400

    uploaded_image = request.files['image']
    temp_path = os.path.join(TEMP_FOLDER, "temp.jpg")
    uploaded_image.save(temp_path)

    try:
        unknown_image = face_recognition.load_image_file(temp_path)
        unknown_encoding = face_recognition.face_encodings(unknown_image)

        if not unknown_encoding:
            print("[ERROR] No face detected in scanned image")
            return jsonify({'error': 'No face detected'}), 400

        unknown_encoding = unknown_encoding[0]

        for filename in os.listdir(REGISTER_FOLDER):
            if filename.endswith(".jpg"):
                reg_image_path = os.path.join(REGISTER_FOLDER, filename)
                reg_image = face_recognition.load_image_file(reg_image_path)
                reg_encoding = face_recognition.face_encodings(reg_image)

                if not reg_encoding:
                    continue

                result = face_recognition.compare_faces([reg_encoding[0]], unknown_encoding)
                if result[0]:
                    emp_id, name = filename.replace('.jpg', '').split('_', 1)
                    timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
                    return jsonify({
                        'status': 'success',
                        'empId': emp_id,
                        'name': name,
                        'timestamp': timestamp,
                        'message': 'Face matched! Check-in successful.'
                    }), 200

        return jsonify({'status': 'fail', 'message': 'No match found'}), 401

    except Exception as e:
        print(f"[ERROR] {str(e)}")
        return jsonify({'error': str(e)}), 500

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5050)



# Iris segmentation + other alternatives 
# admin panel -> backend connection (logs), + 
# shift planning
# geofencing -> constraint (FOR THE LAST ITERATION)
