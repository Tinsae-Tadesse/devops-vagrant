document.getElementById("contactForm").addEventListener("submit", async function (e) {
  e.preventDefault();

  const form = e.target;
  const formData = new FormData(form);

  try {
    const response = await fetch("server-scripts/contact.php", {
      method: "POST",
      body: formData
    });

    const result = await response.text(); // or response.json() if PHP returns JSON

    document.getElementById("formResponse").innerHTML = `<p>${result}</p>`;
    form.reset();
  } catch (error) {
    document.getElementById("formResponse").innerHTML = `<p style="color:red;">Submission failed!</p>`;
    console.error("Error submitting form:", error);
  }
});

