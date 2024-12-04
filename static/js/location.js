async function fetchLocationSuggestions(query) {
    const url = `https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(
        query
    )}&countrycodes=in&addressdetails=1&limit=5`;

    try {
        const response = await fetch(url);
        if (!response.ok) throw new Error('Network response was not ok');
        const data = await response.json();

        return data.map(item => ({
            display_name: item.display_name,
            state: item.address.state || '',
            city:
                item.address.city ||
                item.address.town ||
                item.address.village ||
                '',
        }));
    } catch (error) {
        console.error('Error fetching location suggestions:', error);
        return [];
    }
}

// Update datalist and auto-fill state and city
function updateSuggestions(inputElement, suggestions) {
    const datalist = document.getElementById('location-suggestions');
    datalist.innerHTML = ''; // Clear existing suggestions

    suggestions.forEach(suggestion => {
        const option = document.createElement('option');
        option.value = suggestion.display_name;
        option.dataset.state = suggestion.state;
        option.dataset.city = suggestion.city;
        datalist.appendChild(option);
    });

    // Event listener to handle selection
    inputElement.addEventListener('change', function () {
        const selectedOption = Array.from(datalist.options).find(
            option => option.value === this.value
        );
        if (selectedOption) {
            document.getElementById('state').value =
                selectedOption.dataset.state || '';
            document.getElementById('city').value =
                selectedOption.dataset.city || '';
        }
    });
}

// Attach event listener for fetching suggestions
document.addEventListener('DOMContentLoaded', () => {
    const locationInput = document.getElementById('location');
    locationInput.addEventListener('input', async function () {
        const query = this.value.trim();

        if (query.length > 2) {
            const suggestions = await fetchLocationSuggestions(query);
            updateSuggestions(this, suggestions);
        }
    });
});