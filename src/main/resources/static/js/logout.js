document.addEventListener('DOMContentLoaded', () => {
    console.log("Prima del remove", localStorage.getItem("authToken"));
    window.localStorage.removeItem("authToken");
    console.log("Dopo la remove",localStorage.getItem("authToken"));
})