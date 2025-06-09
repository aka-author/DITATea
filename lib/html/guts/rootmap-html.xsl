<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dtea="http://itsurim.com/dtea" xmlns:xat="http://itsurim.com/xatool"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="dtea xat xs" version="2.0">


    <xsl:import href="../../queries/queries.xsl"/>


    <xsl:template match="*[dtea:isMapTitle(.)]" mode="dtea:isBlock" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>
    

    <xsl:template match="*[dtea:isMapTitle(.)]" mode="dtea:outElementName">
        <xsl:value-of select="'h1'"/>
    </xsl:template>


    <xsl:template match="*[dtea:isMap(.)]" mode="dtea:outElementName">
        <xsl:value-of select="'div'"/>
    </xsl:template>


    <xsl:template match="*[dtea:isMap(.)]">

        <xsl:element name="{dtea:outElementName(.)}">

            <xsl:apply-templates select="." mode="dtea:outAttrs"/>

            <xsl:apply-templates select="//*[dtea:isMapTitle(.)]"/>

            <div class="minor_topics">
                <xsl:apply-templates select="*[dtea:isTopic(.)]"/>
            </div>

        </xsl:element>

    </xsl:template>

</xsl:stylesheet>
