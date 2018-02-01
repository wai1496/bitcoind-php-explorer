#!/usr/bin/env bash

curl -XPUT http://localhost:5984/extn_blocks
curl -XPUT http://localhost:5984/extn_blocks/_design/address -d '{ "_id": "_design/address", "views": { "value": { "reduce": "_sum", "map": "function (doc) {\r\n doc.tx.forEach(function (tx) {\r\n  tx.vout.forEach(function (vout) {\r\n   var ammt = vout.value;\r\n   if(vout.value && vout.value!=0&& vout.scriptPubKey  && vout.scriptPubKey.addresses  )\r\n   vout.scriptPubKey.addresses.forEach(function (addr) {\r\n    emit(addr, vout.value)\r\n   });\r\n\r\n  })\r\n })\r\n}" }, "counter": { "map": " function (doc) {\r\n doc.tx.forEach(function (tx) {\r\n  tx.vout.forEach(function (vout) {\r\n   var ammt = vout.value;\r\n   if(vout.value && vout.value!=0&& vout.scriptPubKey  && vout.scriptPubKey.addresses  )\r\n   vout.scriptPubKey.addresses.forEach(function (addr) {\r\n    emit(addr, tx.txid)\r\n   });\r\n\r\n  })\r\n })\r\n}", "reduce": "_count" } }, "language": "javascript" }'
curl -XPUT http://localhost:5984/extn_blocks/_design/txid    -d '{ "_id": "_design/txid",    "views": { "tx": { "map": "function (doc) {\n  for (var  i  in doc.tx)\n     var tx=doc.tx[i]\n     emit(tx.txid,tx);\n}" } }, "language": "javascript" }'