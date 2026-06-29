# Muslim-Friendly Tourism Ecosystems in Taiwan's Major Cities

## Project Title

**Are Muslim-Friendly Tourism Ecosystems Emerging in Taiwan's Major Cities?**  
**A Spatial Comparison of Taipei, Taichung, and Kaohsiung**

## Authors

Group 9:

- Le Thanh Thao 114266001
- Tran Thi Minh Anh 114266002
- Bitna Han 

Date: June 2026

## Overview

This project investigates whether Muslim-friendly tourism ecosystems are emerging in three major Taiwanese cities: **Taipei, Taichung, and Kaohsiung**. Instead of evaluating destination readiness only by counting halal-certified facilities, the study examines whether hotels, halal restaurants, tourist attractions, prayer facilities, and MRT access are spatially arranged in ways that support real tourist movement.

The study argues that Muslim-friendly tourism readiness should be understood as an **accessibility ecosystem**. A city may have many certified facilities, but those facilities become more useful when they are close to hotels, attractions, prayer spaces, and public transport corridors.

## Research Questions

The main research question is:

> What spatial relationships exist between halal-certified hotels, halal restaurants, tourist attractions, prayer facilities, and MRT access in Taipei, Taichung, and Kaohsiung, and do these relationships indicate the emergence of Muslim-friendly tourism ecosystems at the city level?

The study also asks:

- Are Muslim-friendly tourism resources spatially concentrated or randomly distributed within each city?
- How accessible are halal restaurants, tourist attractions, and prayer facilities from halal-certified hotels?
- Which cities and districts meet the spatial threshold to qualify as Muslim-friendly tourism ecosystems?

## Study Area

The analysis compares three major cities in Taiwan:

- **Taipei**: Taiwan's capital and most mature international tourism gateway.
- **Taichung**: An intermediate urban tourism case with fewer halal-certified accommodation records.
- **Kaohsiung**: A southern metropolitan destination with strong tourism potential and a visible transit corridor.

## Data Sources

The project uses the following spatial data groups:

- Halal-certified hotels and restaurants
- Tourist attractions
- Prayer rooms and mosques
- MRT station coordinates
- Administrative district boundaries

Main sources include:

- Taiwan Tourism Administration Muslim-friendly dining and accommodation records
- Taiwan Tourism Administration open tourist attraction data
- Muslim-friendly facility and mosque records
- MRT station coordinate data
- Ministry of the Interior administrative boundary spatial data
- Halal Formosa as a supplementary contextual source

All spatial layers were projected to **TWD97 / EPSG:3826** so that distance calculations could be measured in meters.

## Methodology

The analysis follows four stages.

### Stage 1: Exploratory Spatial Data Analysis

Facility layers were mapped to compare the spatial distribution of hotels, restaurants, hotel-restaurants, attractions, prayer facilities, and MRT stations across the three cities.

<img width="8100" height="3000" alt="stage1_comparison" src="https://github.com/user-attachments/assets/dd3a0b13-e308-4d48-9891-50a619513145" />

*Figure 1. Muslim-friendly tourism infrastructure in Taipei, Taichung, and Kaohsiung.*

### Stage 2: Distance-Based Accessibility

Nearest-neighbor distances were calculated from each halal-certified hotel to:

- The nearest halal food source
- The nearest tourist attraction
- The nearest prayer facility

Hotel & Restaurant records were treated as both accommodation and halal food infrastructure, but same-facility matches were excluded to avoid artificial zero-distance results.

<img width="3000" height="2100" alt="stage2_boxplots" src="https://github.com/user-attachments/assets/cc2816fc-063a-4e6e-8cf0-541b5830b5d6" />

*Figure 2. Distribution of nearest facility distances by city. Dashed line = 500 m threshold; dotted line = 1 km threshold.*

### Stage 3: Spatial Concentration and MRT Overlay

District-level support intensity, Kernel Density Estimation (KDE), MRT-overlay mapping, and Global Moran's I were used to evaluate spatial concentration. The KDE surface used an 800 m bandwidth, and district-level spatial autocorrelation was tested using queen contiguity weights.

<img width="8400" height="3000" alt="stage3_kde_mrt_comparison" src="https://github.com/user-attachments/assets/e5bb3045-0019-43ae-b88d-31fa98eb934c" />

*Figure 3. KDE concentration map with MRT station proximity overlay.*

### Stage 4: Ecosystem Qualification

A hotel was classified as an ecosystem-qualifying node if it had:

- At least one halal food source within 1 km
- At least one tourist attraction within 1 km

A stricter 500 m threshold was also tested to identify more compact walkable ecosystems. Prayer facilities were reported as supplementary support because they are important for Muslim traveler comfort but are less numerous in the dataset.

<img width="7200" height="3000" alt="stage4_ecosystem_maps" src="https://github.com/user-attachments/assets/b5db2f85-ca34-412a-ba40-fc1a8df75aca" />

*Figure 4. Ecosystem qualification by halal hotel location.*


## Key Results

### Cleaned Facility Counts

| City | Hotels | Hotel & Restaurant | Restaurants | Attractions | Prayer Rooms | Mosques | MRT Stations |
|---|---:|---:|---:|---:|---:|---:|---:|
| Taipei | 43 | 9 | 43 | 80 | 30 | 4 | 73 |
| Taichung | 3 | 4 | 20 | 15 | 3 | 2 | 14 |
| Kaohsiung | 23 | 8 | 5 | 41 | 2 | 2 | 28 |

### Hotel-Based Accessibility

| City | Hotels | Restaurant Median | Restaurant <= 1 km | Attraction Median | Attraction <= 1 km | Prayer Median | Prayer <= 1 km |
|---|---:|---:|---:|---:|---:|---:|---:|
| Kaohsiung | 31 | 634 m | 68% | 419 m | 90% | 1,500 m | 32% |
| Taichung | 7 | 702 m | 57% | 796 m | 57% | 2,076 m | 14% |
| Taipei | 52 | 419 m | 88% | 334 m | 90% | 832 m | 60% |

### Ecosystem Qualification

| City | Hotels | 1 km Qualified | 1 km Rate | 500 m Qualified | 500 m Rate | Prayer within 1 km |
|---|---:|---:|---:|---:|---:|---:|
| Kaohsiung | 31 | 21 | 67.7% | 9 | 29.0% | 32.3% |
| Taichung | 7 | 4 | 57.1% | 2 | 28.6% | 14.3% |
| Taipei | 52 | 43 | 82.7% | 23 | 44.2% | 59.6% |

<img width="2400" height="1800" alt="stage4_qualification_rates" src="https://github.com/user-attachments/assets/c8a9992e-afa3-424c-9502-4574a78a6003" />

*Figure 5. Ecosystem qualification rates at 1 km and 500 m thresholds.*

## Findings

The findings demonstrate that Muslim-friendly tourism readiness should be evaluated through the spatial integration of facilities rather than through facility counts alone. Taipei has both the largest number of Muslim-friendly resources and the strongest spatial coordination among hotels, halal food sources, attractions, prayer facilities, and public transport. However, Kaohsiung shows that a smaller number of facilities can still form meaningful tourism ecosystems when they are concentrated around central attractions and accessible transit corridors. Taichung, by contrast, has a thinner accommodation network and less consistent overlap among tourism resources.
The non-significant Global Moran’s I results indicate that Muslim-friendly facilities do not form broad clusters of adjacent high-support districts. Nevertheless, this does not mean that no spatial pattern exists. The KDE and MRT-overlay maps reveal a finer-grained structure in which facilities tend to concentrate around central areas, transport nodes, and visitor corridors. Therefore, Muslim-friendly tourism ecosystems in Taiwan are better understood as corridor- and node-based accessibility systems than as continuous district-level clusters.
The comparison between the three cities also reflects different stages of ecosystem development. Taipei represents the most mature ecosystem, with 82.7 percent of hotel locations meeting the 1 km qualification threshold. Its main advantage is the consistent proximity of hotels to halal food and tourist attractions, although prayer access remains incomplete in some areas. Kaohsiung can be considered an emerging corridor-based ecosystem, with 67.7 percent of hotels qualifying at 1 km. Its hotels are generally close to attractions, but the city has fewer standalone halal restaurants and prayer facilities. Taichung has the weakest ecosystem, with 57.1 percent of hotels qualifying at 1 km and a very small accommodation sample. Its promising facilities are concentrated in several central districts but remain insufficiently connected.
The sharp decline in qualification rates at the 500 m threshold further shows that many existing ecosystems are accessible but not highly compact. Even in Taipei, the qualification rate falls from 82.7 percent at 1 km to 44.2 percent at 500 m. Kaohsiung and Taichung both fall to approximately 29 percent. This suggests that many Muslim travelers may still depend on public transport, short taxi journeys, or longer walks rather than being able to access all necessary services within an immediately walkable area.
These findings support a targeted planning approach. Rather than distributing new facilities evenly across cities, tourism authorities should identify hotel and attraction areas that are missing only one important component, such as a nearby halal restaurant or prayer space. MRT stations and central visitor corridors should serve as anchors for certification programs, wayfinding systems, multilingual information, and small-scale prayer facilities. Taipei should focus on closing remaining prayer-access gaps, Kaohsiung should strengthen halal dining and prayer support along its central transit corridor, and Taichung should develop a limited number of complete clusters before expanding services more widely.
Finally, physical proximity must be supported by social and digital visibility. A nearby facility may remain difficult to use when its halal status, location, opening hours, or services are unclear. Official tourism websites, digital maps, halal platforms, hotel information, online reviews, and community recommendations should therefore be integrated into destination planning. Combining spatial gap analysis with visitor feedback would help ensure that Muslim-friendly resources are not only geographically accessible but also recognisable, trustworthy, and practically usable.


## Planning Implications

The findings suggest that Muslim-friendly tourism development should focus on spatial gap-closing rather than only increasing facility counts. Useful strategies include:

- Supporting halal certification near hotel areas that already have nearby tourist attractions
- Adding prayer rooms near major attractions, MRT stations, visitor centers, malls, museums, and selected hotels
- Using MRT-accessible districts as anchors for Muslim-friendly tourism planning
- Improving official maps, multilingual information, QR-code guides, and online visibility of certified facilities
- Combining spatial analysis with social feedback from reviews, travel blogs, and Muslim traveler communities

## Conclusion

Muslim-friendly tourism ecosystems are emerging unevenly across Taiwan's major cities. Taipei can be interpreted as a mature but still incomplete ecosystem, Kaohsiung as an emerging corridor-based ecosystem, and Taichung as a developing ecosystem with localized potential.

The main conclusion is that Muslim-friendly tourism readiness is not only an inventory of certified facilities. It is an accessibility ecosystem formed by the spatial relationship among accommodation, halal food, attractions, prayer support, public transport, and trusted visitor information.

## Acknowledgment
I would like to express my sincere gratitude to Prof. Pien for the invaluable advice and insightful guidance provided throughout the development of this research topic.


## References

- Al-Ansi, A., & Han, H. (2019). Role of halal-friendly destination performances, value, satisfaction, and trust in generating destination loyalty. *Journal of Destination Marketing & Management, 14*, 100377.
- Battour, M., & Ismail, M. N. (2016). Halal tourism: Concepts, practises, challenges and future. *Tourism Management Perspectives, 19*, 150-154.
- CrescentRating & Mastercard. (2024). *Global Muslim Travel Index 2024*. CrescentRating.
- Taiwan Tourism Administration. (2026). Muslim-friendly Environment: Dining & Accommodation. https://eng.taiwan.net.tw/m1.aspx?sNo=0020323
- Halal Formosa. (2026). Halal Formosa: Halal map and ingredient scanner in Taiwan. https://halalformosa.com
- Taiwan Tourism Administration Open Data. (2026). Tourist attraction dataset. Ministry of Transportation and Communications, Taiwan.
- Ministry of the Interior, Taiwan. (2026). Administrative boundary spatial data. National land and geospatial open data.
