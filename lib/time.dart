time_now() {
     var h = new DateTime.now().hour.toInt(); // hour
     var timeMood = h < 12 ? 'AM' : 'PM'; // cloc Time Mood
     h = (h > 12) ? h-12 : h; // cloc hour
     h = (h == 0) ? 12 : h; // cloc hour
     var m = new DateTime.now().minute.toString(); // min
     var d = new DateTime.now().day.toString(); // dat
     var M = new DateTime.now().month.toString(); // month
     var y = new DateTime.now().year.toString(); // year

		 String now = "$h:$m $timeMood in $y/$M/$d"; // form Time&Date
     return now;
   }