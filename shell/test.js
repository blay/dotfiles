var s = '';
a='1112031584';
for (let i = 1;i < a.length;i++) {
    if (a[i] % 2 == a[i-1] % 2) {
      s += max(a[i], a[i-1]); 
    }
    
}
