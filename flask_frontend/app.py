from flask import Flask, render_template, request, redirect, url_for, flash
import requests

app = Flask(__name__)
app.secret_key = "dev-secret-key" 

API_BASE = "http://localhost:3000"

#Helpers

def api_get(path):
    r = requests.get(f"{API_BASE}{path}")
    r.raise_for_status()
    return r.json()

def api_post(path, payload):
    r = requests.post(f"{API_BASE}{path}", json=payload)
    return r

def api_put(path, payload):
    r = requests.put(f"{API_BASE}{path}", json=payload)
    return r

def api_delete(path):
    r = requests.delete(f"{API_BASE}{path}")
    return r


#Routes

@app.route("/")
def home():
    return redirect(url_for("hotels_list"))


#Hotels

@app.route("/hotels")
def hotels_list():
    hotels = api_get("/hotels.json")
    return render_template("hotels_list.html", hotels=hotels)


@app.route("/hotels/new", methods=["GET", "POST"])
def hotel_create():
    if request.method == "POST":
        payload = {
            "hotel": {
                "name": request.form["name"],
                "location": request.form["location"],
                "rating": request.form.get("rating") or None,
                "description": request.form.get("description", "")
            }
        }
        resp = api_post("/hotels", payload)
        if resp.status_code == 201:
            flash("Hotel created successfully!", "success")
            return redirect(url_for("hotels_list"))
        else:
            error_message = "Error creating hotel"
            try:
                data = resp.json()
                error_message = ", ".join(data.get("errors", [error_message]))
            except ValueError:
                pass #response has no JSON

            flash(error_message, "danger")
    #GET or failed POST
    return render_template("hotels_form.html", hotel=None, action="Create")
    
@app.route("/hotels/<int:hotel_id>")
def hotel_detail(hotel_id):
    hotel = api_get(f"/hotels/{hotel_id}.json")
    rooms = api_get(f"/hotels/{hotel_id}/rooms.json")
    return render_template("hotel_detail.html", hotel=hotel, rooms=rooms)

@app.route("/hotelS/<int:hotel_id>/edit", methods=["GET", "POST"])
def hotel_edit(hotel_id):
    hotel = api_get(f"/hotels/{hotel_id}.json")

    if request.method == "POST":
        payload = {
            "hotel": {
                "name": request.form["name"],
                "location": request.form["location"],
                "rating": request.form.get("rating") or None,
                "description": request.form.get("description", "")
            }
        }
        resp = api_put(f"/hotels/{hotel_id}", payload)
        if resp.ok:
            flash("Hotel updated successfully!", "success")
            return redirect(url_for("hotel_detail", hotel_id=hotel_id))
        else:
            flash("; ".join(resp.json().get("errors", ["Error updating hotel"])), "danger")

    #GET or failed POST
    return render_template("hotels_form.html", hotel=hotel, action="Update")


@app.route("/hotels/<int:hotel_id>/delete", methods=["POST"])
def hotel_delete(hotel_id):
    resp = api_delete(f"/hotels/{hotel_id}")
    if resp.ok:
        flash("Hotel deleted.", "success")
    else:
        flash("Error deleting hotel.", "danger")
    return redirect(url_for("hotels_list"))


#Rooms

@app.route("/hotels/<int:hotel_id>/rooms/new", methods=["GET", "POST"])
def room_create(hotel_id):
    hotel = api_get(f"/hotels/{hotel_id}.json")
    if request.method == "POST":
        payload = {
            "room":{
                "number": request.form["number"],
                "room_type": request.form["room_type"],
                "price": request.form.get("price") or 0
            }
        }
        resp = api_post(f"/hotels/{hotel_id}/rooms", payload)
        if resp.status_code == 201:
            flash("Room created successfully!", "success")
            return redirect(url_for("hotel_detail", hotel_id=hotel_id))
        else:
            error_message = "Error creating room"
            try:
                errors = resp.json().get("errors", ["Error creating room"])
            except ValueError:
                errors = ["Error creating room"]

            flash(", ".join(errors), "danger")

    return render_template("room_form.html", hotel_id=hotel_id, hotel=hotel, room=None, action="Create")


@app.route("/hotels/<int:hotel_id>/rooms/<int:room_id>/edit", methods=["GET", "POST"])
def room_edit(hotel_id, room_id):
    hotel=api_get(f"/hotels/{hotel_id}.json")
    room = api_get(f"/hotels/{hotel_id}/rooms/{room_id}.json")

    if request.method == "POST":
        payload = {
            "room": {
                "number": request.form["number"],
                "room_type": request.form["room_type"],
                "price": request.form.get("price") or 0
            }
        }
        resp = api_put(f"/hotels/{hotel_id}/rooms/{room_id}", payload)
        if resp.ok:
            flash("Room updated successfully!", "success")
            return redirect(url_for("hotel_detail", hotel_id=hotel_id))
        else:
            flash("; ".join(resp.json().get("errors", ["Error updating room"])), "danger")

    return render_template("room_form.html", hotel_id=hotel_id, hotel=hotel, room=room, action="Update")


@app.route("/hotels/<int:hotel_id>/rooms/<int:room_id>/delete", methods=["POST"])
def room_delete(hotel_id, room_id):
    resp = api_delete(f"/hotels/{hotel_id}/rooms/{room_id}")
    if resp.ok:
        flash("Room deleted.", "success")
    else: 
        flash("Error deleting room.", "danger")
    return redirect(url_for("hotel_detail", hotel_id=hotel_id))


if __name__ == "__main__":
    app.run(debug=True)
