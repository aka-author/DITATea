<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dtea="http://itsurim.com/dtea"
    exclude-result-prefixes="dtea xs" version="2.0">


    <xsl:import href="../../queries/queries.xsl"/>


    <!-- 
        Getting the ID of a topic 
    -->

    <xsl:template match="*" mode="dtea:json.topicId">
        <xsl:value-of select="dtea:id(.)"/>
    </xsl:template>


    <!-- 
        Getting the name of a page a topic will be written to 
    -->

    <xsl:template match="*" mode="dtea:json.topicPageURI">

        <xsl:variable name="id">
            <xsl:apply-templates select="." mode="dtea:json.topicId"/>
        </xsl:variable>

        <xsl:value-of select="concat($id, '.html')"/>
        
    </xsl:template>

</xsl:stylesheet>
