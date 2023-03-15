<html>
    <body>
        <h1>Bomasi prices:</h1>
        <ul>
            <?php
              $json = file_get_contents('http://prices');
              $price_items = json_decode($json)
              foreach ($price_items as $price_item) {
                echo "$price_item->price<br>;"
                #echo "<li>$price_item->price</li>";
              }
            ?>
        </ul>
        <h2>Core Bomasi:</h2>
        <ul>
        <?php
              $json = file_get_contents('http://bomasi');
              $bomasi_items = json_decode($json)
              foreach ($bomasi_items as $bomasi_item) {
                echo "<li>$bomasi_item->name</li>";
              }
            ?>
        </ul>
    </body>
</html>