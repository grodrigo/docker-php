<html>
<head><title>Dockerized Development Stack</title>
<style>
  body {
    width: 100%; 
    background-color: #384d54;
    color:white;
    font-family:Ubuntu;
  }
  a {
    color:white;
    text-decoration:none;
  }

</style>
  <body>
    <div id="main" style="margin: 100px auto 0 auto; width: 800px;">
    <h1 >Dockerized Development Stack</h1>
    <h3>
    http://<?php echo $_SERVER["SERVER_ADDR"].':'.$_SERVER["SERVER_PORT"]; 
    ?>
    </h3>
    <h3>
      Docker ID: <?=getenv('HOSTNAME');?>
    </h3>
    <h3>
      <a href="phpinfo.php">PHP <?php echo  phpversion();?> INFO</a>
    </h3>
    <h3>
      <a href="bench.php">Benchmark</a>
    </h3>
      <img src="docker-logo-400x380.png" alt="Development Stack docker" >
    </div>
  </body>
<?php 
?>
</html>
