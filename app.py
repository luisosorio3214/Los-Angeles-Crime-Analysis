from flask import Flask, render_template


# create our app object 

app = Flask(__name__)

@app.route("/")
@app.route("/Home")
def home_page():
  return render_template("home.html")


if __name__ == "__main__":
  app.run(host='0.0.0.0', debug = True)