
				$.getJSON( "json/list.json" , function( data ) {                                                                   
							console.log(data);
							$.each(data, function ( index , vaule ) {
								console.log(vaule);
								var articlet1 = '<article class="item thumb" data-width="282">';
								var text1 = '<h2>'+ vaule + '</h2>';
								var text2 = '<a href="images/fulls/01.jpg" class="image"><img src="images/thumbs/01.jpg" alt=""></a>';
								var text3 ='</article>' ;
								var t4 = articlet1+text1+text2+text3;
								$ ("#reel").append(t4).delay(10000); 
						   	});
					   	}).fail( function( data ) {
					});
