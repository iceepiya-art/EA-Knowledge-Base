
        async function uploadCSVDiagnosis() {
          const fileInput = document.getElementById('csv-upload');
          if (!fileInput.files || fileInput.files.length === 0) {
            alert("Please select a CSV file first.");
            return;
          }
          
          const btn = event.currentTarget;
          const origHTML = btn.innerHTML;
          btn.innerHTML = '<div class="spinner"></div> Analyzing...';
          btn.disabled = true;
          
          const formData = new FormData();
          formData.append('file', fileInput.files[0]);
          
          try {
            const res = await fetch('http://localhost:5000/api/learning/csv-diagnosis', {
              method: 'POST',
              body: formData
            });
            const data = await res.json();
            
            if (data.error) {
              alert("Error: " + data.error);
            } else {
              document.getElementById('csv-result').style.display = 'block';
              document.getElementById('csv-summary').innerHTML = '<b>Total Trades:</b> ' + data.stats.total_trades + ' | <b>Win Rate:</b> ' + (data.stats.win_rate || 0).toFixed(1) + '% | <b>Profit Factor:</b> ' + (data.stats.profit_factor || 0).toFixed(2) + '<br><br>' + data.diagnosis_summary;
              
              const rulesList = document.getElementById('csv-rules');
              rulesList.innerHTML = '';
              (data.extracted_rules || []).forEach(rule => {
                const li = document.createElement('li');
                li.innerText = rule;
                rulesList.appendChild(li);
              });
              lucide.createIcons();
            }
          } catch (e) {
            alert("Failed to connect to server: " + e.message);
          } finally {
            btn.innerHTML = origHTML;
            btn.disabled = false;
          }
        }
        