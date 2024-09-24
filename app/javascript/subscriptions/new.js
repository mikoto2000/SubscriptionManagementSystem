document.addEventListener("DOMContentLoaded", async (event) => {

  const publisherSelector = document.getElementById("publisher-selector");

  publisherSelector.addEventListener("change", (event) => {
    console.log("👺: KITAYO");
    const newValue = event.target.value

    fetch(`/plans.json?q[publisher_id_in][]=${newValue}`)
      .then((response) => {
        const json = response.json()
          .then((json) => {
            const selectItems = json.map((e) => {
              return {value: e.id, text: e.name}
            });
            console.log(selectItems);

            const selectItemsForTomSelect = selectItems.reduce((acc, item, index) => {
              acc[index + 1] = item;
              return acc;
            }, {})

            const planSelector = document.getElementById("plan-selector");
            console.log(planSelector.tomselect.options);

            planSelector.tomselect.options = selectItemsForTomSelect;
            console.log(planSelector.tomselect.options);

          })
          .catch((e) => {
            console.error(e);
          })
      })
      .catch((e) =>{
        console.error(e);
      });
  });
});
